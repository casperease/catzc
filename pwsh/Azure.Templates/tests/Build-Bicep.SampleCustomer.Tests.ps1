# cspell:ignore alweutstscusst alweutstscusacst
Describe 'sample-customer (per-customer build)' -Tag 'L0', 'logic' {
    # Mocks and the config-cache reset run once; only the build output folder is wiped per test, since the tests write into it.
    BeforeAll {
        # Redirects build output to this file's TestDrive, so it never shares out/template/<name> with another build test file.
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-customer'

        . (Join-Path $PSScriptRoot 'BicepParams.Fixture.ps1')
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
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warms the discovery and config caches once, so no It pays the cold derive inside its own timing.
        Get-BicepTemplate sample-customer | Out-Null
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
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
        Join-Path $script:outputRoot 'parameters.acme.alpha-001.json' | Should -Exist   # slot 001 of acme
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

    It 'throws once when one slot fails to compile, naming that slot and its customer' {
        Mock Invoke-ExecutableParallel {
            foreach ($line in $Command) {
                if ($line -like '*parameters.acme.alpha-001.bicepparam*') {
                    [Catzc.Base.Execution.CliResult]::new('', 'widget error', 1)
                    continue
                }
                if (-not (& $script:compileBicepParams $line) -and $line -match ' build "' -and $line -match '--outdir "([^"]+)"') {
                    [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
                }
                [Catzc.Base.Execution.CliResult]::new('', '', 0)
            }
        } -ModuleName Catzc.Azure.Templates
        $message = { Build-Bicep sample-customer | Out-Null } | Should -Throw -PassThru |
            ForEach-Object { $_.Exception.Message }
        $message | Should -BeLike "*1 of * bicep compile(s) failed*slot '*alpha-001*' (customer 'acme') failed with exit code 1*widget error*"
        ([regex]::Matches($message, 'failed with exit code')).Count | Should -Be 1 -Because 'only the one failing slot is named'
    }

    It 'builds only the configuration-root slots with -Shared' {
        Build-Bicep sample-customer -Shared | Out-Null
        Join-Path $script:outputRoot 'parameters.alpha.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.acme.alpha.json' | Should -Not -Exist
    }
}
