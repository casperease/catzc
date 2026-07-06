Describe 'Build-Bicep (sample-with-prepost merge seam)' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-with-prepost'
        # Resolve identity from the test config fixture (mock active for this block + its tests).
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        # The merge seam injects the vnet ranges from the network fixture — resolve the expected,
        # per-env values straight from the asset so the test tracks it.
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
        # The Bicep CLI gate now lives in Catzc.Azure.Cli; mock the boundary so its internal az probe never runs.
        Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates

        # Warm the path-keyed session caches once, not per test (ADR-TEST#19).
        Get-Config -Config azure | Out-Null
        Get-BicepTemplates | Out-Null
    }

    BeforeEach {
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    AfterAll {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'merges the vnet ranges from the network plan into parameters.core_lower.alpha.json' {
        Build-Bicep sample-with-prepost -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.addressPrefix.value | Should -Be $script:alphaNetwork.vnet_address_space
        $json.parameters.subnetPrefix.value | Should -Be $script:alphaNetwork.default_subnet
    }

    It 'passes the configured vnetName through alongside the merged ranges' {
        Build-Bicep sample-with-prepost -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.vnetName.value | Should -Be 'alpha-weu-tst-sppp-vnet'
    }

    It 'merges the per-environment ranges (alpha and beta differ)' {
        Build-Bicep sample-with-prepost | Out-Null
        $alpha = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $beta = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.beta.json') -Raw | ConvertFrom-Json
        $alpha.parameters.addressPrefix.value | Should -Be $script:alphaNetwork.vnet_address_space
        $beta.parameters.addressPrefix.value | Should -Be $script:betaNetwork.vnet_address_space
        $alpha.parameters.addressPrefix.value | Should -Not -Be $beta.parameters.addressPrefix.value
    }

    It 'injects values (the ranges) the per-slot config does not carry' {
        $configuration = Get-Content (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates/sample-with-prepost/configuration/core_lower/alpha.yml') -Raw | ConvertFrom-Yaml
        $configuration.ParametersFile.parameters.Contains('addressPrefix') | Should -BeFalse -Because 'the merge seam, not the config, supplies the ranges'
        Build-Bicep sample-with-prepost -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.addressPrefix.value | Should -Be $script:alphaNetwork.vnet_address_space
    }

    It 'injects an ARM Key Vault reference for sharedReference, derived from fixture identity not config' {
        # The config does NOT carry the value — the hook injects an ARM KV *reference* (the production
        # pattern for keeping deploy-time secrets out of the repo, here proven on a fixture so no test binds
        # to a real template's secret name).
        $configuration = Get-Content (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates/sample-with-prepost/configuration/core_lower/alpha.yml') -Raw | ConvertFrom-Yaml
        $configuration.ParametersFile.parameters.Contains('sharedReference') | Should -BeFalse -Because 'the KV reference is injected by the hook, not carried by config'

        Build-Bicep sample-with-prepost -Environments alpha | Out-Null
        $reference = (Get-Content (Join-Path $script:outputRoot 'parameters.core_lower.alpha.json') -Raw | ConvertFrom-Json).parameters.sharedReference.reference

        # Secret name is derived from the template's OWN short_name (fixture-defined), never a production literal.
        $templateDescriptor = Get-BicepTemplate sample-with-prepost
        $reference.secretName | Should -Be "$($templateDescriptor.short_name)-shared-secret"

        # Vault id is well-formed ARM and carries the resolved fixture subscription id.
        $subscriptionId = (Get-AzureSubscription -Subscription core_lower).id
        $reference.keyVault.id | Should -Match '^/subscriptions/.+/providers/Microsoft\.KeyVault/vaults/.+$'
        $reference.keyVault.id | Should -BeLike "*$subscriptionId*"
    }

    It 'surfaces PrePost.psm1 on template descriptor via discovery' {
        $templateDescriptor = Get-BicepTemplate sample-with-prepost
        $templateDescriptor.prepost_module | Should -Not -BeNullOrEmpty
        $templateDescriptor.prepost_module | Should -Match 'PrePost\.psm1$'
    }

    It 'copies PrePost.psm1 into the build output folder' {
        Build-Bicep sample-with-prepost -Environments alpha | Out-Null
        Join-Path $script:outputRoot 'PrePost.psm1' | Should -Exist
    }
}
