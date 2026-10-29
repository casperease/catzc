function Build-Bicep {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
        Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding(DefaultParameterSetName = 'RuntimeSlots')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [string[]] $Environments,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string[]] $Customers,

        [switch] $Shared,

        [Parameter(ParameterSetName = 'RuntimeSlots')]
        [ValidatePattern('^[a-z][a-z0-9]*-[a-z0-9]{1,3}$', Options = 'None')]
        [string[]] $RuntimeSlots,

        [Parameter(ParameterSetName = 'RuntimeSlotsJson')]
        [string] $RuntimeSlotsJson,

        [string] $OutputFolder
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $outputFolder = if ($OutputFolder) {
        $OutputFolder
    }
    else {
        $templateDescriptor.output_folder
    }

    # Every slot by default; -Environments narrows by environment, -Customers and -Shared by configuration axis, unioned when both are given.
    $targetSlots = @($templateDescriptor.slots)
    if ($Environments) {
        $targetSlots = @($targetSlots | Where-Object { $_.environment -in $Environments })
    }
    if ($Customers -or $Shared) {
        $targetSlots = @($targetSlots | Where-Object {
                ($Customers -and $_.customer -in $Customers) -or ($Shared -and $_.customer -eq '')
            })
    }
    if ($PSCmdlet.ParameterSetName -eq 'RuntimeSlotsJson') {
        $RuntimeSlots = @(ConvertFrom-BicepRuntimeSlotsJson -Json $RuntimeSlotsJson)
    }
    # @($null) is one null element, so an unset parameter is filtered to no runtime slot at all.
    foreach ($runtime in @($RuntimeSlots | Where-Object { $_ })) {
        $environment, $slotName = $runtime -split '-', 2
        $bases = @($targetSlots | Where-Object { $_.environment -eq $environment -and $_.slot -eq '' })
        if ($bases.Count -eq 0) {
            throw "Runtime slot '$runtime' of template '$Template' has no base slot '$environment' among the slots selected"
        }
        foreach ($base in $bases) {
            $ephemeral = Resolve-BicepSlot -TemplateDescriptor $templateDescriptor -Environment $environment -Slot $slotName -Customer $base.customer
            if (-not @($targetSlots | Where-Object { $_.name -eq $ephemeral.name -and $_.customer -eq $ephemeral.customer })) {
                $targetSlots += $ephemeral
            }
        }
    }
    if ($targetSlots.Count -eq 0) {
        throw "No slots to build for template '$Template' (requested environments: $($Environments -join ', '); customers: $($Customers -join ', ')$(if ($Shared) { ' + shared' }); available environments: $($templateDescriptor.environments -join ', '))"
    }

    # Before the output is wiped: the bicep binary from tools.yml, resolved once, so each compile skips the az start and a version probe.
    $bicep = Resolve-ToolExecutable -Tool bicep
    if (-not $bicep.Found) {
        throw 'bicep is not installed (no managed bicep found). Run Install-Bicep.'
    }
    if (-not $bicep.VersionOk) {
        throw "bicep at $($bicep.Path) reports version '$($bicep.Version)', but tools.yml pins '$($bicep.Required)'. Run Install-Bicep."
    }

    if (Test-Path $outputFolder -PathType Container) {
        Remove-Item $outputFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

    $prepareHook = Get-BicepPrepareHook -TemplateDescriptor $templateDescriptor

    # The output folder is self-contained: main.bicep and every file it reaches are copied in, and each slot's using names that copy.
    $main = Copy-BicepSourceTree -Main $templateDescriptor.main -OutputFolder $outputFolder
    $using = [System.IO.Path]::GetRelativePath($outputFolder, $main).Replace('\', '/')
    $usingLine = [regex]::new("(?m)^(\s*using\s+)'[^']*'")
    # Each compile is a full bicep process over the template, so every slot's build-params and the main.bicep build run side by side.
    $compiles = [System.Collections.Generic.List[object]]::new()
    foreach ($slot in $targetSlots) {
        $environment = $slot.environment
        $paramsPath = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $environment -Slot $slot.slot -Customer $slot.customer)
        $bicepParamPath = [System.IO.Path]::ChangeExtension($paramsPath, '.bicepparam')
        if ($slot.format -eq [Catzc.Azure.Templates.BicepSlot]::BicepparamFormat) {
            $source = [System.IO.File]::ReadAllText($slot.file)
            [System.IO.File]::WriteAllText($bicepParamPath, $usingLine.Replace($source, "`$1'$using'", 1))
        }
        else {
            $preparedDescriptor = Get-BicepPreparedConfiguration -TemplateDescriptor $templateDescriptor -Slot $slot -PrepareHook $prepareHook
            [System.IO.File]::WriteAllText($bicepParamPath,
                (ConvertTo-BicepParam -Descriptor $preparedDescriptor -Using $using))
        }
        $compiles.Add([pscustomobject]@{
                Label      = "bicep build-params of slot '$($slot.name)'$(if ($slot.customer) { " (customer '$($slot.customer)')" })"
                Command    = "`"$($bicep.Path)`" build-params `"$bicepParamPath`" --outfile `"$paramsPath`""
                Source     = $bicepParamPath
                Parameters = $paramsPath
            })
    }
    $compiles.Add([pscustomobject]@{
            Label      = "bicep build of '$main'"
            Command    = "`"$($bicep.Path)`" build `"$main`" --outdir `"$outputFolder`""
            Source     = $main
            Parameters = $null
        })

    $cacheEntry = $null
    $cacheLock = $null
    if ($env:CATZC_BICEP_BUILD_CACHE) {
        $keyHash = [System.Security.Cryptography.IncrementalHash]::CreateHash([System.Security.Cryptography.HashAlgorithmName]::SHA256)
        $binaryStamp = [System.IO.File]::GetLastWriteTimeUtc($bicep.Path).Ticks
        $keyHash.AppendData([System.Text.Encoding]::UTF8.GetBytes("bicep $($bicep.Path) $binaryStamp`n"))
        $preparedFiles = [string[]] @(Get-ChildPath $outputFolder -File -Depth 16 -Exclude @() -PruneVendor $false)
        [System.Array]::Sort($preparedFiles, [System.StringComparer]::Ordinal)
        foreach ($preparedFile in $preparedFiles) {
            $keyHash.AppendData([System.Text.Encoding]::UTF8.GetBytes([System.IO.Path]::GetRelativePath($outputFolder, $preparedFile).Replace('\', '/') + "`n"))
            $keyHash.AppendData([System.IO.File]::ReadAllBytes($preparedFile))
        }
        $key = [System.Convert]::ToHexString($keyHash.GetHashAndReset())
        $cacheEntry = Join-Path $env:CATZC_BICEP_BUILD_CACHE $key
        # One builder per key at a time: a second file wanting the same template waits for the first compile instead of racing it.
        $cacheLock = [System.Threading.Mutex]::new($false, "Local\catzc-bicep-build-$key")
        try {
            if (-not $cacheLock.WaitOne([TimeSpan]::FromSeconds((Get-TimeoutSeconds -Command Build-Bicep)))) {
                $cacheLock.Dispose()
                $cacheLock = $null
                throw "Template '$Template': another worker of this test run held the bicep build cache key $key past Build-Bicep's time limit."
            }
        }
        catch [System.Threading.AbandonedMutexException] {
            Write-Message "Template '$Template': a worker died holding the bicep build cache key $key; building it here."
        }
    }
    try {
        $cachedOutputs = @(if ($cacheEntry -and [System.IO.Directory]::Exists($cacheEntry)) {
                [System.IO.Directory]::GetFiles($cacheEntry, '*.json')
            })
        if ($cachedOutputs.Count -gt 0) {
            Write-Message "Restoring $main and $($compiles.Count - 1) slot(s) to $outputFolder from the run's build cache"
            foreach ($cachedOutput in $cachedOutputs) {
                [System.IO.File]::Copy($cachedOutput, (Join-Path $outputFolder ([System.IO.Path]::GetFileName($cachedOutput))), $true)
            }
            $results = @(foreach ($compile in $compiles) {
                    [pscustomobject]@{ ExitCode = 0; Errors = ''; Full = '' }
                })
        }
        else {
            Write-Message "Building $main and $($compiles.Count - 1) slot(s) to $outputFolder"
            $results = @(Invoke-ExecutableParallel -Command @($compiles | ForEach-Object Command) -NoAssert -Silent)
            # Only a whole real compile is kept (bicep stamps itself as main.json's generator), so a test's stand-in never reaches a real build.
            $builtMain = Join-Path $outputFolder 'main.json'
            if ($cacheEntry -and -not @($results | Where-Object { $_.ExitCode -ne 0 }) -and [System.IO.File]::Exists($builtMain) -and
                [System.IO.File]::ReadAllText($builtMain).Contains('"name": "bicep"')) {
                $staging = "$cacheEntry.$PID"
                [void][System.IO.Directory]::CreateDirectory($staging)
                foreach ($output in @($builtMain) + @($compiles | Where-Object Parameters | ForEach-Object Parameters)) {
                    if ([System.IO.File]::Exists($output)) {
                        [System.IO.File]::Copy($output, (Join-Path $staging ([System.IO.Path]::GetFileName($output))), $true)
                    }
                }
                [System.IO.Directory]::Move($staging, $cacheEntry)
            }
        }
    }
    finally {
        if ($cacheLock) {
            $cacheLock.ReleaseMutex()
            $cacheLock.Dispose()
        }
    }
    $failures = [System.Collections.Generic.List[string]]::new()
    for ($index = 0; $index -lt $compiles.Count; $index++) {
        $compile = $compiles[$index]
        $result = $results[$index]
        if ($result.ExitCode -ne 0) {
            $failures.Add("$($compile.Label) failed with exit code $($result.ExitCode):`n$($result.Full)")
            continue
        }
        if ($result.Errors) {
            Write-Message "$($compile.Label):`n$($result.Errors)"
        }
    }
    if ($failures.Count -gt 0) {
        throw "Template '$Template': $($failures.Count) of $($compiles.Count) bicep compile(s) failed:`n$($failures -join "`n")"
    }
    foreach ($compile in @($compiles | Where-Object Parameters)) {
        Assert-PathExist $compile.Parameters -PathType Leaf -ErrorText (
            "bicep build-params reported success but wrote no '$($compile.Parameters)' from '$($compile.Source)'; check its output above.")
        Write-Message "Wrote $($compile.Parameters)"
    }

    # Asserted here because the Bicep CLI is proved available, so a missing main.json is an unexpected build failure, not a missing install.
    $mainJson = Join-Path $outputFolder 'main.json'
    Assert-PathExist $mainJson -PathType Leaf -ErrorText (
        "bicep build reported success (exit 0) but wrote no main.json to '$outputFolder'. " +
        'The Bicep CLI was verified available before the build, so this is an unexpected build ' +
        "failure — check the 'bicep build' output above for warnings or errors."
    )

    if ($null -ne $templateDescriptor.prepost_module) {
        Copy-Item $templateDescriptor.prepost_module $outputFolder
    }

    if ($null -ne $templateDescriptor.resources) {
        $resourcesOut = Join-Path $outputFolder 'resources'
        New-Item -ItemType Directory -Path $resourcesOut -Force | Out-Null
        foreach ($file in $templateDescriptor.resources) {
            Copy-Item $file $resourcesOut
        }
    }

    $outputFolder
}
