# cspell:ignore weutstsidxst
Describe 'sample-indexed (indexed slots)' -Tag 'L0', 'logic' {
    # Mocks and the config-cache reset run once; only the build output folder is wiped per test, since the tests write into it.
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-indexed'

        . (Join-Path $PSScriptRoot 'BicepParams.Fixture.ps1')
        Mock Invoke-Executable {
            if (& $script:compileBicepParams $Command) {
                return
            }
            if ($Command -match ' build "' -and $Command -match '--outdir "([^"]+)"') {
                [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
            }
        } -ModuleName Catzc.Azure.Templates
        # The bicep binary is resolved through the toolchain; mock the boundary so no version probe runs.
        Mock Resolve-ToolExecutable { [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'bicep' } } -ModuleName Catzc.Azure.Templates
        # Devbox path: under CI the real detector returns true and the deployment-name test then needs ADO-only BUILD_BUILDID, which GitHub Actions lacks.
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warms the discovery and config caches once; BeforeEach wipes only the build output, not the caches.
        Get-BicepTemplate sample-indexed | Out-Null
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

    It 'discovers indexed config files as distinct slots' {
        $templateDescriptor = Get-BicepTemplate sample-indexed
        $names = @($templateDescriptor.slots | ForEach-Object { $_.name })
        $names | Should -Contain 'alpha-001'
        $names | Should -Contain 'alpha-002'
        # both slots are the same environment (alpha), two slots
        @($templateDescriptor.slots | ForEach-Object { $_.environment } | Select-Object -Unique) | Should -Be @('alpha')
        ($templateDescriptor.slots | Where-Object { $_.name -eq 'alpha-001' } | Select-Object -First 1).slot |
            Should -Be '001'
    }

    It "a slot-less call selects the env's base slot, which this template does not have" {
        # Without -Slot, alpha resolves to config 'alpha', which this indexed-only template lacks (it has alpha-001 and alpha-002).
        { Get-BicepTemplateConfiguration sample-indexed alpha } | Should -Throw "*no config 'alpha.yml'*"
    }

    It 'passes a distinct configured storageAccountName through per slot' {
        Build-Bicep sample-indexed | Out-Null
        $a001 = Get-Content (Join-Path $script:outputRoot 'parameters.alpha-001.json') -Raw | ConvertFrom-Json
        $a002 = Get-Content (Join-Path $script:outputRoot 'parameters.alpha-002.json') -Raw | ConvertFrom-Json
        $a001.parameters.storageAccountName.value | Should -Be 'al001weutstsidxst'
        $a002.parameters.storageAccountName.value | Should -Be 'al002weutstsidxst'
    }

    It 'derives a distinct resource group per slot (one config file maps to one RG)' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample-indexed -Environment alpha -Slot 001 } |
            Should -Be 'alpha-001-weu-tst-sidx-rg'
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample-indexed -Environment alpha -Slot 002 } |
            Should -Be 'alpha-002-weu-tst-sidx-rg'
    }

    It 'builds one parameters file per slot (two RGs for one env)' {
        Build-Bicep sample-indexed | Out-Null
        Join-Path $script:outputRoot 'parameters.alpha-001.json' | Should -Exist
        Join-Path $script:outputRoot 'parameters.alpha-002.json' | Should -Exist
    }

    It 'puts the slot in the deployment name so slots never collide' {
        Get-BicepDeploymentName sample-indexed -Environment alpha -Slot 001 |
            Should -BeLike 'sample-indexed-alpha-001-*'
        Get-BicepDeploymentName sample-indexed -Environment alpha -Slot 002 |
            Should -BeLike 'sample-indexed-alpha-002-*'
    }
}
