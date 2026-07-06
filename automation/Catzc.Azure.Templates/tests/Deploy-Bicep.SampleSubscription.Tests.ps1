Describe 'Get-BicepDeploymentContext (sample-subscription)' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-subscription'

        Mock Build-Bicep {
            $outputFolder = (Get-BicepTemplate $Template).output_folder
            New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
            foreach ($file in 'main.json', 'parameters.alpha.json', 'parameters.beta.json') {
                Set-Content -Path (Join-Path $outputFolder $file) -Value '{}'
            }
            $outputFolder
        } -ModuleName Catzc.Azure.Templates

        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        # The deploy target is the az session's subscription (ADR-PESTER:3 whole-boundary mock).
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'core_lower'; id = '50a0ed00-de00-50b0-0000-000000000000'; customer = ''
                tenant = [ordered]@{ name = 'fixtenant'; id = 'fa0e0000-7e0a-0700-1d00-000000000000' }
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }

        # Warm the path-keyed session caches once, not per test (ADR-TEST#19).
        Get-Config -Config azure | Out-Null
        Get-Config -Config network | Out-Null
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

    It 'resolves deployment.target = Subscription' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample-subscription
        $context.deployment.target | Should -Be 'Subscription'
    }

    It 'omits resource_group for a Subscription-target template' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample-subscription
        $context.deployment.resource_group | Should -BeNullOrEmpty
    }

    It 'throws when a Subscription template config carries a ResourceGroup key' {
        Mock Get-BicepTemplateConfiguration {
            [ordered]@{
                ResourceGroup  = 'rg-should-not-be-here'
                ParametersFile = [ordered]@{ parameters = [ordered]@{} }
            }
        } -ModuleName Catzc.Azure.Templates

        { Get-BicepDeploymentContext -Environment alpha -Template sample-subscription } |
            Should -Throw '*Subscription-target*ResourceGroup*'
    }
}

Describe 'Deploy-Bicep (sample-subscription sub create)' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:tempArtifacts = Join-Path ([IO.Path]::GetTempPath()) ('catzc-subdeploy-' + [Guid]::NewGuid())

        # Devbox path: without this the real Test-IsRunningInPipeline returns $true under CI
        # ($env:GITHUB_ACTIONS) and Deploy-Bicep throws "requires -SubscriptionIdAssertIs in a pipeline".
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        Mock Deploy-AzureResourceGroup { } -ModuleName Catzc.Azure.Templates
        Mock Set-BicepTrackingTagSet { } -ModuleName Catzc.Azure.Templates
        # sample-subscription ships no PrePost.psm1, so no pre/post hooks run (no-op).
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "properties:`n  provisioningState: Succeeded"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Templates

        $tempFolder = $script:tempArtifacts
        Mock Get-BicepDeploymentContext {
            [ordered]@{
                template    = 'sample-subscription'
                deployment  = [ordered]@{
                    name   = 'sample-subscription-CLI-test'
                    mode   = 'Incremental'
                    target = 'Subscription'
                }
                artifacts   = [ordered]@{
                    did_local_build = $true
                    folder          = $tempFolder
                    template_file   = (Join-Path $tempFolder 'main.json')
                    parameters_file = (Join-Path $tempFolder 'parameters.alpha.json')
                }
                environment = [ordered]@{
                    name         = 'alpha'
                    region       = 'westeurope'
                    subscription = [ordered]@{
                        name     = 'core_lower'
                        id       = '50a0ed00-de00-50b0-0000-000000000000'
                        customer = ''
                        tenant   = [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' }
                    }
                }
            }
        } -ModuleName Catzc.Azure.Templates

        # Warm the path-keyed session caches once, not per test (ADR-TEST#19).
        Get-Config -Config azure | Out-Null
        Get-BicepTemplates | Out-Null
    }

    BeforeEach {
        if (Test-Path $script:tempArtifacts) {
            Remove-Item $script:tempArtifacts -Recurse -Force
        }
        New-Item -ItemType Directory -Path $script:tempArtifacts -Force | Out-Null
        Set-Content -Path (Join-Path $script:tempArtifacts 'main.json') -Value '{}'
        Set-Content -Path (Join-Path $script:tempArtifacts 'parameters.alpha.json') -Value '{}'
    }

    AfterAll {
        if (Test-Path $script:tempArtifacts) {
            Remove-Item $script:tempArtifacts -Recurse -Force
        }
    }

    It 'invokes az deployment sub create with --location and --what-if' {
        Deploy-Bicep alpha sample-subscription -DryRun
        $expectedTemplate = [regex]::Escape("--template-file `"$(Join-Path $script:tempArtifacts 'main.json')`"")
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $Arguments -match '^deployment sub create' -and
            $Arguments -match '--name "sample-subscription-CLI-test"' -and
            $Arguments -match '--location westeurope' -and
            $Arguments -match $expectedTemplate -and
            $Arguments -match '--what-if' -and
            $Arguments -notmatch '--resource-group'
        }
    }

    It 'does not ensure a resource group for a Subscription-target deploy' {
        Deploy-Bicep alpha sample-subscription -DryRun
        Should -Invoke Deploy-AzureResourceGroup -ModuleName Catzc.Azure.Templates -Times 0
    }
}

Describe 'Get-BicepTrackTagNameSet (sample-subscription)' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }

        # Warm the path-keyed session caches once, not per test (ADR-TEST#19).
        Get-Config -Config azure | Out-Null
        Get-BicepTemplates | Out-Null
    }

    It 'returns template-prefixed tag names for a Subscription-target template' {
        $tags = Get-BicepTrackTagNameSet sample-subscription
        $tags.commit | Should -Be 'sample-subscription_Deployed_From_Commit'
        $tags.build_id | Should -Be 'sample-subscription_Deployed_From_BuildId'
        $tags.branch | Should -Be 'sample-subscription_Deployed_From_Branch'
    }
}
