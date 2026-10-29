# cspell:ignore alweufxosmplst
Describe 'Build-Bicep' -Tag 'L0', 'logic' {
    # Mocks and the config-cache reset run once; only the build output folder is wiped per test, since the tests write into it.
    BeforeAll {
        . (Join-Path $PSScriptRoot 'BicepParams.Fixture.ps1')
        # Own output root through the seam, so a sibling worker building the sample fixture cannot race the shared out/template/sample.
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep/template/sample'
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep'
        } -ModuleName Catzc.Azure.Templates

        Mock Invoke-ExecutableParallel {
            foreach ($line in $Command) {
                if (-not (& $script:compileBicepParams $line) -and $line -match ' build "' -and $line -match '--outdir "([^"]+)"') {
                    [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
                }
                [Catzc.Base.Execution.CliResult]::new('', '', 0)
            }
        } -ModuleName Catzc.Azure.Templates
        # The bicep binary is resolved through the toolchain; mock the boundary so no version probe runs.
        Mock Resolve-ToolExecutable { [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'bicep' } } -ModuleName Catzc.Azure.Templates
        # Discover from the test fixtures and resolve identity from the test config fixture.
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warms the discovery and config caches here, so the cold re-derive after the reset is setup cost, not the first test's duration.
        Get-BicepTemplates | Out-Null
        Get-Config -Config azure | Out-Null
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    AfterAll {
        if ($script:outputRoot -and [System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    It 'renders one parameters.json per configured environment' {
        Build-Bicep sample | Out-Null
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.beta.json' | Should -Exist
    }

    It 'passes the configured storageAccountName through to parameters.json' {
        Build-Bicep sample -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.storageAccountName.value | Should -Be 'alweufxosmplst'
    }

    It 'filters environments when -Environments is provided' {
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.beta.json' | Should -Not -Exist
    }

    It 'invokes bicep build with the template main path and outdir' {
        Build-Bicep sample | Out-Null
        Should -Invoke Invoke-ExecutableParallel -ModuleName Catzc.Azure.Templates -ParameterFilter {
            @($Command | Where-Object { $_ -match ' build "' -and $_ -match 'main\.bicep' -and $_ -match 'outdir' }).Count -eq 1
        }
    }

    It 'returns the output folder path' {
        $result = Build-Bicep sample
        $result | Should -Be $script:outputRoot
    }

    It 'wipes any pre-existing output folder' {
        New-Item -ItemType Directory -Path $script:outputRoot -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $script:outputRoot 'stale.txt') -Force | Out-Null
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $script:outputRoot 'stale.txt' | Should -Not -Exist
    }

    It 'builds into -OutputFolder and returns it, leaving the default folder and another run''s folder untouched' {
        $first = Join-Path $TestDrive 'run-1'
        $second = Join-Path $TestDrive 'run-2'
        Build-Bicep sample -Environments alpha -OutputFolder $first | Should -Be $first
        Build-Bicep sample -Environments alpha -OutputFolder $second | Should -Be $second
        Join-Path $first 'parameters.alpha.json' | Should -Exist -Because 'a second run wipes only its own folder'
        Join-Path $first 'main.json' | Should -Exist
        Join-Path $second 'main.json' | Should -Exist
        $script:outputRoot | Should -Not -Exist -Because 'a run-scoped build never touches the default output folder'
    }

    It 'throws on an unknown template via ValidateScript' {
        { Build-Bicep nonexistent } | Should -Throw
    }

    It 'throws when -Environments filter excludes every configured environment' {
        { Build-Bicep sample -Environments bogus } | Should -Throw '*No slots*'
    }

    It 'throws on a config value that is the UNDEFINED marker, but not on a boolean true or another case' {
        Mock ConvertTo-FlatSettingSet -ModuleName Catzc.Azure.Templates { [ordered]@{ 'widget.enabled' = $true; 'widget.note' = 'undefined' } }
        { Build-Bicep sample -Environments alpha } | Should -Not -Throw
        Mock ConvertTo-FlatSettingSet -ModuleName Catzc.Azure.Templates { [ordered]@{ 'widget.enabled' = $true; 'gadget.size' = 'UNDEFINED' } }
        { Build-Bicep sample -Environments alpha } | Should -Throw "*Undefined config key 'gadget.size'*"
    }

    It 'asserts the bicep binary is installed and at the pinned version before building' {
        Mock Resolve-ToolExecutable { [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null } } -ModuleName Catzc.Azure.Templates
        { Build-Bicep sample -Environments alpha } | Should -Throw '*Run Install-Bicep*'
        Mock Resolve-ToolExecutable {
            [pscustomobject]@{ Found = $true; VersionOk = $false; Path = 'bicep'; Version = '0.1.0'; Required = '9.9.9' }
        } -ModuleName Catzc.Azure.Templates
        { Build-Bicep sample -Environments alpha } | Should -Throw "*pins '9.9.9'*"
        Should -Invoke Invoke-ExecutableParallel -ModuleName Catzc.Azure.Templates -Times 0
    }

    It 'throws when bicep build exits 0 but produces no main.json' {
        # Bicep available, but the build emits nothing -> the post-build assert fires at the source.
        Mock Invoke-ExecutableParallel {
            foreach ($line in $Command) {
                # bicep build: simulate exit 0 with no compiled output.
                $null = & $script:compileBicepParams $line
                [Catzc.Base.Execution.CliResult]::new('', '', 0)
            }
        } -ModuleName Catzc.Azure.Templates
        { Build-Bicep sample -Environments alpha } | Should -Throw '*no main.json*'
    }
}

Describe 'Build-Bicep (real bicep)' -Tag 'L2', 'logic', 'greedy' {
    BeforeAll {
        # Same isolated root as the mocked block; one file runs in one worker, so its blocks never overlap.
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep/template/sample'
    }

    BeforeEach {
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep'
        } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
    }

    AfterAll {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'produces main.json + parameters.alpha.json with real bicep build' {
        $bicep = Resolve-ToolExecutable -Tool bicep
        if (-not ($bicep.Found -and $bicep.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $script:outputRoot 'main.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Exist
    }
}
