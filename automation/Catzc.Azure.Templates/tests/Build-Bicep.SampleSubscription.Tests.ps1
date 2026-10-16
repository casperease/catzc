<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
    folder: tests
    name: build-bicep-sample-subscription-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleSubscription.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#{4,19,26}
      - ADR-PWSH-PESTER#2
---
#>

Describe 'Build-Bicep (sample-subscription)' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-subscription'

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

        Get-BicepTemplate sample-subscription | Out-Null
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    It 'discovers the template with deployment_target Subscription' {
        (Get-BicepTemplate sample-subscription).deployment_target | Should -Be 'Subscription'
    }

    It 'passes the configured resourceGroupName through to parameters.json' {
        Build-Bicep sample-subscription -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.resourceGroupName.value | Should -Be 'alpha-weu-tst-ssub-rg'
    }
}
