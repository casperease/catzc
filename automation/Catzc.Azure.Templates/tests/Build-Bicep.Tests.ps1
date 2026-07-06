# cspell:ignore alweutstsmplst
Describe 'Build-Bicep' -Tag 'L0', 'logic' {
    # Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
    # build output folder is wiped per test, since the build tests write into it (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        # Own output root through the seam: any other file building the 'sample' fixture from a sibling
        # worker can race the shared out/template/sample (ADR-TEST:26 — remove the sharing).
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep/template/sample'
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep'
        } -ModuleName Catzc.Azure.Templates

        Mock Invoke-AzCli {
            if ($Arguments -match 'bicep version') {
                return [pscustomobject]@{ Output = 'Bicep CLI version 999.999.999'; ExitCode = 0 }
            }
            if ($Arguments -match 'bicep build' -and $Arguments -match '--outdir "([^"]+)"') {
                [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Assert-Tool { } -ModuleName Catzc.Azure.Templates
        # The Bicep CLI gate now lives in Catzc.Azure.Cli; mock the boundary so its internal az probe never runs.
        Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Templates
        # Discover from the test fixtures and resolve identity from the test config fixture.
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warm the discovery and config caches once, here — the cold re-derive the reset above forces is
        # one-time setup cost, not the first test's duration (ADR-TEST:19; it kept tipping that test just
        # over the L0 limit).
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
        Join-Path $script:outputRoot 'parameters.core_lower.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.core_lower.beta.json' | Should -Exist
    }

    It 'passes the configured storageAccountName through to parameters.json' {
        Build-Bicep sample -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.storageAccountName.value | Should -Be 'alweutstsmplst'
    }

    It 'filters environments when -Environments is provided' {
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $script:outputRoot 'parameters.core_lower.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.core_lower.beta.json' | Should -Not -Exist
    }

    It 'invokes az bicep build with the template main path and outdir' {
        Build-Bicep sample | Out-Null
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $Arguments -match 'bicep build' -and
            $Arguments -match 'main\.bicep' -and
            $Arguments -match 'outdir'
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

    It 'throws on an unknown template via ValidateScript' {
        { Build-Bicep nonexistent } | Should -Throw
    }

    It 'throws when -Environments filter excludes every configured environment' {
        { Build-Bicep sample -Environments bogus } | Should -Throw '*No slots*'
    }

    It 'asserts the Bicep CLI is available before building' {
        # The Bicep CLI gate (Assert-AzCliBicep, in Catzc.Azure.Cli) throws -> Build-Bicep stops before any
        # az bicep build runs. Mock the gate boundary (its own az-version behaviour is covered in Cli tests).
        Mock Assert-AzCliBicep { throw 'Bicep CLI not available. Run az bicep install.' } -ModuleName Catzc.Azure.Templates
        { Build-Bicep sample -Environments alpha } | Should -Throw '*az bicep install*'
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 0 -ParameterFilter { $Arguments -match 'bicep build' }
    }

    It 'throws when az bicep build exits 0 but produces no main.json' {
        # Bicep available, but the build emits nothing -> the post-build assert fires at the source.
        Mock Invoke-AzCli {
            if ($Arguments -match 'bicep version') {
                return [pscustomobject]@{ Output = 'Bicep CLI version 999.999.999'; ExitCode = 0 }
            }
            # bicep build: simulate exit 0 with no compiled output.
        } -ModuleName Catzc.Azure.Templates
        { Build-Bicep sample -Environments alpha } | Should -Throw '*no main.json*'
    }
}

Describe 'Build-Bicep (real az)' -Tag 'L2', 'logic' {
    BeforeAll {
        # Own output root through the seam (see the mocked-az block's note) — same isolated root as that
        # block: one file runs in one worker, so its blocks never overlap each other.
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep/template/sample'
    }

    BeforeEach {
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/build-bicep'
        } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
    }

    AfterAll {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'produces main.json + parameters.core_lower.alpha.json with real az bicep build' {
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $script:outputRoot 'main.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.core_lower.alpha.json' | Should -Exist
    }
}
