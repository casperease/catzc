# cspell:ignore weutstsidxst
Describe 'sample-indexed (indexed slots)' -Tag 'L0', 'logic' {
    # Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
    # build output folder is wiped per test, since the build tests write into it (ADR-AUTO-TEST:19/ADR-AUTO-TEST:4).
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-indexed'

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
        # Devbox path: under CI the real Test-IsRunningInPipeline returns $true ($env:GITHUB_ACTIONS), and the
        # deployment-name test then hits Get-BicepDeploymentName's pipeline branch, which requires ADO-only
        # $env:BUILD_BUILDID and throws on GitHub Actions.
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warm the discovery + config caches once, so the first It doesn't pay the cold Get-BicepTemplate
        # derive (template-tree enumeration + config load) inside its own timing (ADR-AUTO-TEST:19). Every test
        # here reads the same fixture template, and BeforeEach wipes only the build output, not the caches.
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
        # both slots are the same environment (alpha), different slots
        @($templateDescriptor.slots | ForEach-Object { $_.environment } | Select-Object -Unique) | Should -Be @('alpha')
        ($templateDescriptor.slots | Where-Object { $_.name -eq 'alpha-001' } | Select-Object -First 1).slot | Should -Be '001'
    }

    It "a slot-less call selects the env's base slot, which this template does not have" {
        # alpha with no -Slot resolves to config 'alpha', which this indexed-only template does not
        # configure (it has alpha-001 / alpha-002).
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
        Get-BicepDeploymentName sample-indexed -Environment alpha -Slot 001 | Should -BeLike 'sample-indexed-alpha-001-*'
        Get-BicepDeploymentName sample-indexed -Environment alpha -Slot 002 | Should -BeLike 'sample-indexed-alpha-002-*'
    }
}
