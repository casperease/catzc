function Build-Bicep {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
        Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
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

        [switch] $Shared
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $outputFolder = $templateDescriptor.output_folder

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
    if ($targetSlots.Count -eq 0) {
        throw "No slots to build for template '$Template' (requested environments: $($Environments -join ', '); customers: $($Customers -join ', ')$(if ($Shared) { ' + shared' }); available environments: $($templateDescriptor.environments -join ', '))"
    }

    # Before the output is wiped: a missing or blocked Bicep install can make az bicep build exit 0 and write no main.json.
    Assert-AzCliBicep

    if (Test-Path $outputFolder -PathType Container) {
        Remove-Item $outputFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

    # A template's own PrePost.psm1 may export the prepare hook; absent, the slot's configuration is used unchanged.
    $prepareHook = $null
    $havePrePost = $null -ne $templateDescriptor.prepost_module
    if ($havePrePost) {
        Write-Message "Importing per-template PrePost module: $($templateDescriptor.prepost_module)"
        $prepostModule = Import-Module $templateDescriptor.prepost_module -Scope Local -Force -PassThru
        # Hooks run strict whoever wrote them, like every catzc module.
        . $prepostModule { Set-StrictMode -Version Latest }
        if ($prepostModule.ExportedCommands.ContainsKey('Invoke-BicepPrepareParameterSet')) {
            $prepareHook = $prepostModule.ExportedCommands['Invoke-BicepPrepareParameterSet']
        }
    }

    # Every slot deploys as a .bicepparam in the output folder whose using names main.bicep in the tree, so its module tree resolves.
    $using = [System.IO.Path]::GetRelativePath($outputFolder, $templateDescriptor.main).Replace('\', '/')
    $usingLine = [regex]::new("(?m)^(\s*using\s+)'[^']*'")
    foreach ($slot in $targetSlots) {
        $environment = $slot.environment
        $paramsPath = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $environment -Slot $slot.slot -Customer $slot.customer)
        $bicepParamPath = [System.IO.Path]::ChangeExtension($paramsPath, '.bicepparam')
        if ($slot.format -eq [Catzc.Azure.Templates.BicepSlot]::BicepparamFormat) {
            $source = [System.IO.File]::ReadAllText($slot.file)
            [System.IO.File]::WriteAllText($bicepParamPath, $usingLine.Replace($source, "`$1'$using'", 1))
            Invoke-BicepParamsBuild -BicepParamPath $bicepParamPath -ParametersPath $paramsPath
            continue
        }
        $configurationDescriptor = Get-BicepTemplateConfiguration $Template $environment -Slot $slot.slot -Customer $slot.customer

        $flat = $configurationDescriptor | ConvertTo-FlatSettingSet
        foreach ($key in $flat.Keys) {
            # String-first and case-sensitive: -eq would coerce a boolean true or a number to equal the marker.
            if ($flat[$key] -is [string] -and 'UNDEFINED' -ceq $flat[$key]) {
                throw "Undefined config key '$key' for slot '$($slot.name)' in template '$Template'"
            }
        }

        # Addressed parameters resolve to their value before the hook, so the hook and the parameters file see only ARM entries.
        if ($configurationDescriptor.Contains('ParametersFile') -and
            $configurationDescriptor.ParametersFile -is [System.Collections.IDictionary] -and
            $configurationDescriptor.ParametersFile.Contains('parameters') -and
            $configurationDescriptor.ParametersFile.parameters -is [System.Collections.IDictionary]) {
            $configFolder = if ([string]::IsNullOrEmpty($slot.customer)) {
                $templateDescriptor.configuration_folder
            }
            else {
                Join-Path $templateDescriptor.configuration_folder $slot.customer
            }
            $configurationDescriptor.ParametersFile.parameters = Resolve-BicepParameterAddresses -Parameters $configurationDescriptor.ParametersFile.parameters -ConfigFile (Join-Path $configFolder "$($slot.name).yml")
        }

        # Hooks read their dimensions from this invocation, not raw params, so a new dimension never changes the hook signature.
        $buildInvocation = [ordered]@{
            Template     = $Template
            Environment  = $environment
            Slot         = $slot.slot
            Subscription = $slot.subscription
            Customer     = $slot.customer
        }
        $preparedDescriptor = if ($prepareHook) {
            & $prepareHook -BuildInvocation $buildInvocation -TemplateDescriptor $templateDescriptor -ConfigurationDescriptor $configurationDescriptor
        }
        else {
            $configurationDescriptor
        }

        Assert-True ($null -ne $preparedDescriptor) -ErrorText "PrePost Invoke-BicepPrepareParameterSet returned null for $Template / $($slot.name)"
        if (-not $preparedDescriptor.Contains('ParametersFile')) {
            throw "Prepared configuration for $Template / $($slot.name) is missing 'ParametersFile' (check the template's PrePost.psm1)"
        }

        [System.IO.File]::WriteAllText($bicepParamPath,
            (ConvertTo-BicepParam -Descriptor $preparedDescriptor -Using $using))
        Invoke-BicepParamsBuild -BicepParamPath $bicepParamPath -ParametersPath $paramsPath
    }

    Write-Message "Building $($templateDescriptor.main) to $outputFolder"
    Invoke-AzCli "bicep build --file `"$($templateDescriptor.main)`" --outdir `"$outputFolder`""

    # Asserted here because the Bicep CLI is proved available, so a missing main.json is an unexpected build failure, not a missing install.
    $mainJson = Join-Path $outputFolder 'main.json'
    Assert-PathExist $mainJson -PathType Leaf -ErrorText (
        "az bicep build reported success (exit 0) but wrote no main.json to '$outputFolder'. " +
        'The Bicep CLI was verified available before the build, so this is an unexpected build ' +
        "failure — check the 'az bicep build' output above for warnings or errors."
    )

    if ($havePrePost) {
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
