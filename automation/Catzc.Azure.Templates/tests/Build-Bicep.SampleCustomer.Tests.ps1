# cspell:ignore alweutstscusst alweutstscusacst
Describe 'sample-customer (per-customer build)' -Tag 'L0', 'logic' {
    # Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
    # build output folder is wiped per test, since the build tests write into it (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-customer'

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

    It 'writes core and per-customer parameter files with customer-prefixed names' {
        Build-Bicep sample-customer | Out-Null
        Join-Path $script:outputRoot 'parameters.core_lower.alpha.json' | Should -Exist            # core
        Join-Path $script:outputRoot 'parameters.acme_lower.alpha.json' | Should -Exist       # acme base
    }

    It 'builds a mixed template — acme has both a base (no-slot) and a slotted config' {
        Build-Bicep sample-customer | Out-Null
        Join-Path $script:outputRoot 'parameters.acme_lower.alpha.json' | Should -Exist       # acme base slot
        Join-Path $script:outputRoot 'parameters.acme_lower.alpha-001.json' | Should -Exist   # acme slot 001
    }

    It 'passes the per-(customer,slot) storageAccountName through' {
        Build-Bicep sample-customer | Out-Null
        $core = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $acme = Get-Content (Join-Path $script:outputRoot 'parameters.acme_lower.alpha.json') -Raw | ConvertFrom-Json
        $core.parameters.storageAccountName.value | Should -Be 'alweutstscusst'
        $acme.parameters.storageAccountName.value | Should -Be 'alweutstscusacst'
    }

    It 'builds only the named subscription with -Subscriptions' {
        Build-Bicep sample-customer -Subscriptions acme_lower | Out-Null
        Join-Path $script:outputRoot 'parameters.acme_lower.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.core_lower.alpha.json' | Should -Not -Exist
    }
}
