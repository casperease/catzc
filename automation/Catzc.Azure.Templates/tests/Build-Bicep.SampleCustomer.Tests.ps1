# cspell:ignore alweutstscusst alweutstscusacst
# serial: wipes and rebuilds the shared out/template/sample-customer folder, which Build-Bicep.L2.Tests.ps1
# also builds — a parallel worker would race it (see the test-automation ADR's serial tag).
Describe 'sample-customer (per-customer build)' -Tag 'L0', 'logic', 'serial' {
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
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
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

    It 'writes root and per-customer parameter files mirroring the configuration tree' {
        Build-Bicep sample-customer | Out-Null
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Exist            # configuration root
        Join-Path $script:outputRoot 'parameters.acme.alpha.json' | Should -Exist       # acme base
    }

    It 'builds a mixed template — acme has both a base (no-slot) and a slotted config' {
        Build-Bicep sample-customer | Out-Null
        Join-Path $script:outputRoot 'parameters.acme.alpha.json' | Should -Exist       # acme base slot
        Join-Path $script:outputRoot 'parameters.acme.alpha-001.json' | Should -Exist   # acme slot 001
    }

    It 'passes the per-(customer,slot) storageAccountName through' {
        Build-Bicep sample-customer | Out-Null
        $shared = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $acme = Get-Content (Join-Path $script:outputRoot 'parameters.acme.alpha.json') -Raw | ConvertFrom-Json
        $shared.parameters.storageAccountName.value | Should -Be 'alweutstscusst'
        $acme.parameters.storageAccountName.value | Should -Be 'alweutstscusacst'
    }

    It 'builds only the named customer with -Customers' {
        Build-Bicep sample-customer -Customers acme | Out-Null
        Join-Path $script:outputRoot 'parameters.acme.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Not -Exist
    }

    It 'builds only the configuration-root slots with -Shared' {
        Build-Bicep sample-customer -Shared | Out-Null
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.acme.alpha.json' | Should -Not -Exist
    }
}
