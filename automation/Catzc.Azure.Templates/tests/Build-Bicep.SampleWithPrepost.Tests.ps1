<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
    folder: tests
    name: build-bicep-sample-with-prepost-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{19,20}
---
#>

Describe 'Build-Bicep (sample-with-prepost merge seam)' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-with-prepost'
        # Resolve identity from the test config fixture (mock active for this block + its tests).
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        $script:alphaNetwork = (Get-Config -Config network).environments.alpha
        $script:betaNetwork = (Get-Config -Config network).environments.beta

        Mock Invoke-AzCli {
            if ($Arguments -match 'bicep version') {
                return [pscustomobject]@{ Output = 'Bicep CLI version 999.999.999'; ExitCode = 0 }
            }
            if ($Arguments -match 'bicep build' -and $Arguments -match '--outdir "([^"]+)"') {
                Set-Content -Path (Join-Path $Matches[1] 'main.json') -Value '{}' -NoNewline
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Assert-Tool { } -ModuleName Catzc.Azure.Templates
        # The Bicep CLI guard lives in Catzc.Azure.Cli; mock the boundary so its internal az probe never runs.
        Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates

        Get-Config -Config azure | Out-Null
        Get-BicepTemplates | Out-Null

        $script:configRoot = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates/sample-with-prepost/configuration'
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-with-prepost | Out-Null
        $script:alphaJson = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $script:betaJson = Get-Content (Join-Path $script:outputRoot 'parameters.beta.json') -Raw | ConvertFrom-Json
        $script:prepostCopied = Test-Path (Join-Path $script:outputRoot 'PrePost.psm1')
        $script:templateDescriptor = Get-BicepTemplate sample-with-prepost
    }

    AfterAll {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'merges the vnet ranges from the network plan into parameters.alpha.json' {
        $script:alphaJson.parameters.addressPrefix.value | Should -Be $script:alphaNetwork.vnet_address_space
        $script:alphaJson.parameters.subnetPrefix.value | Should -Be $script:alphaNetwork.default_subnet
    }

    It 'passes the configured vnetName through alongside the merged ranges' {
        $script:alphaJson.parameters.vnetName.value | Should -Be 'alpha-weu-tst-sppp-vnet'
    }

    It 'merges the per-environment ranges (alpha and beta differ)' {
        $script:alphaJson.parameters.addressPrefix.value | Should -Be $script:alphaNetwork.vnet_address_space
        $script:betaJson.parameters.addressPrefix.value | Should -Be $script:betaNetwork.vnet_address_space
        $script:alphaJson.parameters.addressPrefix.value | Should -Not -Be $script:betaJson.parameters.addressPrefix.value
    }

    It 'injects values (the ranges) the per-slot config does not carry' {
        $configuration = Get-Content (Join-Path $script:configRoot 'alpha.yml') -Raw | ConvertFrom-Yaml
        $configuration.ParametersFile.parameters.Contains('addressPrefix') | Should -BeFalse -Because 'the merge seam, not the config, supplies the ranges'
        $script:alphaJson.parameters.addressPrefix.value | Should -Be $script:alphaNetwork.vnet_address_space
    }

    It 'injects an ARM Key Vault reference for sharedReference, derived from fixture identity not config' {
        $configuration = Get-Content (Join-Path $script:configRoot 'alpha.yml') -Raw | ConvertFrom-Yaml
        $configuration.ParametersFile.parameters.Contains('sharedReference') | Should -BeFalse -Because 'the KV reference is injected by the hook, not carried by config'

        $reference = $script:alphaJson.parameters.sharedReference.reference

        # Secret name is derived from the template's OWN short_name (fixture-defined), never a production literal.
        $reference.secretName | Should -Be "$($script:templateDescriptor.short_name)-shared-secret"

        # Vault id is well-formed ARM and carries the resolved fixture subscription id.
        $subscriptionId = (Get-AzureSubscription -Subscription core_lower).id
        $reference.keyVault.id | Should -Match '^/subscriptions/.+/providers/Microsoft\.KeyVault/vaults/.+$'
        $reference.keyVault.id | Should -BeLike "*$subscriptionId*"
    }

    It 'surfaces PrePost.psm1 on template descriptor via discovery' {
        $script:templateDescriptor.prepost_module | Should -Not -BeNullOrEmpty
        $script:templateDescriptor.prepost_module | Should -Match 'PrePost\.psm1$'
    }

    It 'copies PrePost.psm1 into the build output folder' {
        $script:prepostCopied | Should -BeTrue
    }
}
