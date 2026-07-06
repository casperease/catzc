# cspell:ignore alweutstsmodst
# serial: wipes and rebuilds the shared out/template/sample-with-module folder, which Build-Bicep.L2.Tests.ps1
# also builds — a parallel worker would race it (see the test-automation ADR's serial tag).
Describe 'sample-with-module (reusable module consumer)' -Tag 'L0', 'logic', 'serial' {
    # Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
    # build output folder is wiped per test, since the build tests write into it (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-with-module'

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
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
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

    It 'is discovered as a template under infrastructure/templates' {
        Get-BicepTemplateNames | Should -Contain 'sample-with-module'
    }

    It 'does not discover infrastructure/modules (or its files) as templates' {
        $names = Get-BicepTemplateNames
        $names | Should -Not -Contain 'modules'
        $names | Should -Not -Contain 'storage-account'
    }

    It 'uses a statically-configured name that matches Get-BicepResourceName' {
        $expected = Get-BicepResourceName -Template sample-with-module -Environment alpha -Type st
        $expected | Should -Be 'alweutstsmodst'
    }

    It 'renders the configured storageAccountName into parameters.core_lower.alpha.json' {
        Build-Bicep sample-with-module -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.storageAccountName.value | Should -Be 'alweutstsmodst'
    }
}
