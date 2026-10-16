<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
    folder: tests
    name: build-bicep-sample-with-module-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithModule.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{4,19,26}
      - ADR-PWSH-PESTER#2
---
#>

# cspell:ignore alweutstsmodst
Describe 'sample-with-module (reusable module consumer)' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-with-module'

        Mock Invoke-AzCli {
            if ($Arguments -match 'bicep version') {
                return [pscustomobject]@{ Output = 'Bicep CLI version 999.999.999'; ExitCode = 0 }
            }
            if ($Arguments -match 'bicep build' -and $Arguments -match '--outdir "([^"]+)"') {
                [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Assert-Tool { } -ModuleName Catzc.Azure.Templates
        # The Bicep CLI guard lives in Catzc.Azure.Cli; mock the boundary so its internal az probe never runs.
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

        Get-BicepTemplate sample-with-module | Out-Null
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
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

    It 'renders the configured storageAccountName into parameters.alpha.json' {
        Build-Bicep sample-with-module -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.storageAccountName.value | Should -Be 'alweutstsmodst'
    }
}
