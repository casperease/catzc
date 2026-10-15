<#
.SYNOPSIS
    Quality gate: builds the selected modules once into a temporary destination and verifies the built artifact.
.DESCRIPTION
    Every issue is prefixed with its facet and all are collected, so one run shows every broken part.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-AUTO-TEST#24](/docs/adr/automation/test-automation.md#rule-adr-auto-test24),
    [ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md#comment1)
.PARAMETER Module
    Giving neither -Module nor -ModuleProfile builds the default bundle's profile.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md#comment2)
.PARAMETER ModuleProfile
    A module profile (profiles.yml) to build.
.PARAMETER Facet
    The types facet alone builds nothing; any other facet builds once and also checks the build facet.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md#comment3)
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-build-artifact).
.PARAMETER PassThru
    Without it the gate throws on issues, so the result object is how a caller reads them instead.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md#comment4)
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-BuildArtifact
.EXAMPLE
    Test-BuildArtifact -Module Catzc.Base.Config -Facet Load -PassThru
#>
function Test-BuildArtifact {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ArgumentCompleter({ Get-AutomationModules })]
        [string[]] $Module = @(),

        [string] $ModuleProfile,

        [ValidateSet('Types', 'Load', 'Parity', 'Manifest')]
        [string[]] $Facet,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    # @() around the whole if: a one-facet selection must stay an array.
    $selected = @(if ($Facet) {
            $Facet
        }
        else {
            'Types', 'Load', 'Parity', 'Manifest'
        })
    $repositoryRoot = Get-RepositoryRoot
    $automationRoot = Join-Path $repositoryRoot 'automation'
    $issues = [System.Collections.Generic.List[string]]::new()
    $facts = [ordered]@{ Modules = 0; TypesHash = '' }

    if ('Types' -in $selected) {
        foreach ($reason in @(Get-CommittedTypesDrift -RepositoryRoot $repositoryRoot)) {
            $issues.Add("[types] $reason")
        }
    }

    if (@($selected | Where-Object { $_ -ne 'Types' }).Count -gt 0) {
        $selection = @{}
        if ($Module.Count -gt 0) {
            $selection['Module'] = $Module
        }
        if ($ModuleProfile) {
            $selection['ModuleProfile'] = $ModuleProfile
        }

        $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-build-artifact-' + [guid]::NewGuid().ToString('N'))
        try {
            $build = $null
            try {
                $build = Build-Modules @selection -VendorPolicy full -Destination $destination -Silent
            }
            catch {
                # Build-Modules collects every violation (its merge preconditions, Assert-CatzcBundle) into one throw.
                foreach ($line in @($_.Exception.Message -split '\r?\n' | Where-Object { $_ })) {
                    $issues.Add("[build] $line")
                }
            }

            if ($null -ne $build) {
                $buildRoot = [string] $build.BuildRoot
                $builtModules = [string[]] @($build.Modules)
                $facts.Modules = $builtModules.Count
                $facts.TypesHash = "$($build.TypesHash)"

                Import-InternalModule Types
                $sourceHash = (Get-CombinedTypeHash $automationRoot).CombinedHash
                if ("$($build.TypesHash)" -ne "$sourceHash") {
                    $issues.Add("[build] the build's typesHash $($build.TypesHash) is not the source tree's $sourceHash — a build ships the full type set")
                }

                if ('Load' -in $selected -or 'Parity' -in $selected) {
                    $scopeModule = if ('Catzc.Base.Config' -in $builtModules) {
                        'Catzc.Base.Config'
                    }
                    else {
                        $builtModules[0]
                    }
                    $run = Invoke-BuildArtifactProbe -BuildRoot $buildRoot -RepositoryRoot $repositoryRoot -ScopeModule $scopeModule
                    $observed = $run.Observed
                    if ($run.ExitCode -ne 0 -or $null -eq $observed) {
                        $issues.Add("[load] the build does not load in a fresh pwsh (exit $($run.ExitCode)): $($run.Output)")
                    }
                    else {
                        $loaded = @{}
                        foreach ($entry in @($observed.Modules)) {
                            $loaded[$entry.Name] = $entry
                        }

                        if ('Load' -in $selected) {
                            $expectedRepository = [System.IO.Path]::GetFullPath($repositoryRoot)
                            if ($observed.RunMode -ne 'build') {
                                $issues.Add("[load] the session runs in '$($observed.RunMode)' mode, not build mode")
                            }
                            if ($observed.ModulesRoot -ne $buildRoot) {
                                $issues.Add("[load] the code root is '$($observed.ModulesRoot)', not the build root")
                            }
                            if ($observed.RepositoryRoot -ne $expectedRepository -or $observed.Repository -ne $expectedRepository) {
                                $issues.Add("[load] the working root is '$($observed.RepositoryRoot)', not the repository")
                            }
                            foreach ($name in $builtModules) {
                                if (-not $loaded.ContainsKey($name)) {
                                    $issues.Add("[load] $name is built but does not load")
                                    continue
                                }
                                $entry = $loaded[$name]
                                if ($entry.Base -ne (Join-Path $buildRoot $name)) {
                                    $issues.Add("[load] $name loads from '$($entry.Base)', not the build root")
                                }
                                if (@($entry.Exported).Count -eq 0) {
                                    $issues.Add("[load] $name exports no function")
                                }
                                if ($entry.Instances -ne 1) {
                                    $issues.Add("[load] $name loads $($entry.Instances) times (Get-Module -All); a merged file never adds a same-named nested module")
                                }
                            }
                            foreach ($name in @($loaded.Keys | Where-Object { $_ -notin $builtModules } | Sort-Object)) {
                                $issues.Add("[load] $name loads but was not built")
                            }
                            foreach ($base in @($observed.InternalBases)) {
                                if ($base -ne (Join-Path $buildRoot '.internal')) {
                                    $issues.Add("[load] an internal module loads from '$base', not the build's .internal")
                                }
                            }
                            if ($observed.TypesAssembly -ne "Catzc.Types.$($build.TypesHash).dll") {
                                $issues.Add("[load] the session loads the types assembly '$($observed.TypesAssembly)', not the build's Catzc.Types.$($build.TypesHash).dll")
                            }
                            if (-not $observed.Accelerator) {
                                $issues.Add('[load] the type accelerators do not resolve')
                            }
                            if ($observed.HasConfig) {
                                if ($observed.ConfigCount -eq 0) {
                                    $issues.Add('[load] the build ships no config')
                                }
                                foreach ($failure in @($observed.ConfigFailures)) {
                                    $issues.Add("[load] a shipped config does not load: $failure")
                                }
                                if ($observed.ModuleRoot -ne (Join-Path $buildRoot 'Catzc.Base.Config/configs/configs.yml')) {
                                    $issues.Add("[load] module content resolves to '$($observed.ModuleRoot)', not under the build")
                                }
                                if (-not $observed.HelpSynopsis -or $observed.HelpSynopsis -like 'Get-Config *') {
                                    $issues.Add('[load] comment-based help is lost in the merged file (Get-Config has no synopsis)')
                                }
                                if ($observed.Private) {
                                    $issues.Add('[load] a private function (Resolve-ConfigEntry) is exported')
                                }
                            }
                            if ($observed.InModuleScope -ne $true) {
                                $issues.Add("[load] InModuleScope cannot enter $scopeModule")
                            }
                        }

                        if ('Parity' -in $selected) {
                            foreach ($name in $builtModules) {
                                if (-not $loaded.ContainsKey($name)) {
                                    continue
                                }
                                $source = Get-ModuleSourceFunctions -AutomationRoot $automationRoot -Name $name
                                $exported = [string[]] @($loaded[$name].Exported)
                                $private = [string[]] @($loaded[$name].Defined | Where-Object { $_ -notin $exported })
                                foreach ($pair in @(
                                        @{ Kind = 'exports'; Expected = [string[]] @($source.Public); Actual = $exported }
                                        @{ Kind = 'private functions'; Expected = [string[]] @($source.Private); Actual = $private }
                                    )) {
                                    $difference = @(
                                        foreach ($function in $pair.Expected) {
                                            if ($function -notin $pair.Actual) {
                                                "<=$function"
                                            }
                                        }
                                        foreach ($function in $pair.Actual) {
                                            if ($function -notin $pair.Expected) {
                                                "=>$function"
                                            }
                                        })
                                    if ($difference.Count -gt 0) {
                                        $issues.Add("[parity] $name $($pair.Kind) differ from its source folder (<= source only, => build only): $($difference -join ', ')")
                                    }
                                }
                            }
                        }
                    }
                }

                if ('Manifest' -in $selected) {
                    $manifests = @(Join-Path $buildRoot 'Catzc.psd1') + @(foreach ($name in $builtModules) {
                            Join-Path $buildRoot "$name/$name.psd1"
                        })
                    foreach ($result in @(Format-Code -Language powershell -Path $manifests -DryRun -PassThru)) {
                        foreach ($file in $result.ChangedFiles) {
                            $relative = [System.IO.Path]::GetRelativePath($buildRoot, $file) -replace '\\', '/'
                            $issues.Add("[manifest] $relative is not formatter-stable — Format-Code would rewrite the built manifest")
                        }
                    }
                }
            }
        }
        finally {
            if ([System.IO.Directory]::Exists($destination)) {
                [System.IO.Directory]::Delete($destination, $true)
            }
        }
    }

    Write-QualityGateReport -Subject build-artifact -Title Test-BuildArtifact -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
