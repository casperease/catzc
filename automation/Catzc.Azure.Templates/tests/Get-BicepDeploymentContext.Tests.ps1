Describe 'Get-BicepDeploymentContext (devbox)' -Tag 'L0', 'logic' {
    # The config/template boundary is mocked ONCE for the whole block and the config cache reset ONCE: every
    # test reads the same fixture config, and Get-Config keys its cache on the resolved (fixture) path, so the
    # first call derives it cold (~80ms) and the rest hit the warm cache. A per-test configCache reset would
    # force that cold re-derive on every test (ADR-TEST:19/ADR-TEST:4). Per-test we only wipe the (cheap) build folder,
    # which a couple of tests depend on being clean.
    BeforeAll {
        # Own output root through the seam: any other file building the 'sample' fixture from a sibling
        # worker can race the shared out/template/sample (ADR-TEST:26 — remove the sharing). Kept
        # under the repo because the repo-relative artifact contract is asserted below.
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/deployment-context/template/sample'
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/deployment-context'
        } -ModuleName Catzc.Azure.Templates

        # Mock Build-Bicep to materialize stub artifacts without invoking az ([System.IO], not the file cmdlets:
        # ~0.1ms vs ~20ms/call — ADR-TEST:18).
        Mock Build-Bicep {
            $outputFolder = (Get-BicepTemplate $Template).output_folder
            [System.IO.Directory]::CreateDirectory($outputFolder) | Out-Null
            foreach ($file in 'main.json', 'parameters.alpha.json', 'parameters.beta.json') {
                [System.IO.File]::WriteAllText((Join-Path $outputFolder $file), '{}')
            }
            $outputFolder
        } -ModuleName Catzc.Azure.Templates

        # The deploy target is the az session's subscription — the whole-boundary session mock stands in
        # for the service connection / az account set (ADR-PESTER:3).
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'core_lower'; id = '00000000-0000-0000-0000-000000000002'; customer = ''
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates

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
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    AfterAll {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'returns the three concern objects: deployment, artifacts, environment' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.deployment | Should -Not -BeNullOrEmpty
        $context.deployment.template | Should -Be 'sample'
        $context.artifacts | Should -Not -BeNullOrEmpty
        $context.environment | Should -Not -BeNullOrEmpty
    }

    It 'deployment.name follows the standard pattern' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.deployment.name | Should -BeLike 'sample-*-*'
    }

    It 'deployment.mode and target default to Incremental / ResourceGroup' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.deployment.mode | Should -Be 'Incremental'
        $context.deployment.target | Should -Be 'ResourceGroup'
    }

    It 'deployment.resource_group is derived from the slot + naming standard for RG-target templates' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.deployment.resource_group | Should -Be 'alpha-weu-tst-smpl-rg'
    }

    It 'artifacts.did_local_build is true on devbox (Build-Bicep is invoked)' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.artifacts.did_local_build | Should -BeTrue
        Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 1 -Exactly
    }

    It 'artifacts.did_local_build is false with -DoNotRebuild (Build-Bicep is NOT invoked)' {
        [System.IO.Directory]::CreateDirectory($script:outputRoot) | Out-Null
        foreach ($file in 'main.json', 'parameters.alpha.json') {
            [System.IO.File]::WriteAllText((Join-Path $script:outputRoot $file), '{}')
        }

        $context = Get-BicepDeploymentContext -Environment alpha -Template sample -DoNotRebuild
        $context.artifacts.did_local_build | Should -BeFalse
        Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 0
    }

    It 'artifacts.template_file points at main.json' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.artifacts.template_file | Should -BeLike '*main.json'
    }

    It 'artifacts.parameters_file points at parameters.alpha.json for alpha (a configuration-root slot)' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.artifacts.parameters_file | Should -BeLike '*parameters.alpha.json'
    }

    It 'stores artifact paths repo-root-relative on devbox (build output lives under the repo)' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.artifacts.folder | Should -Be 'out/test-isolation/deployment-context/template/sample'
        $context.artifacts.template_file | Should -Be 'out/test-isolation/deployment-context/template/sample/main.json'
        $context.artifacts.parameters_file | Should -Be 'out/test-isolation/deployment-context/template/sample/parameters.alpha.json'
        [IO.Path]::IsPathRooted($context.artifacts.template_file) | Should -BeFalse
    }

    It 'environment is the resolved Get-AzureEnvironment with embedded subscription' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context.environment.name | Should -Be 'alpha'
        $context.environment.subscription.name | Should -Be 'core_lower'
    }

    It 'throws when the environment is in azure.yml but not in the template list' {
        # gamma is in the fixture azure.yml, but sample only configures alpha + beta
        { Get-BicepDeploymentContext -Environment gamma -Template sample } | Should -Throw '*not configured for template*'
    }

    It 'throws when -DoNotRebuild is set but the build folder is missing' {
        # outputRoot was wiped in BeforeEach; no Build-Bicep invocation will populate it
        { Get-BicepDeploymentContext -Environment alpha -Template sample -DoNotRebuild } | Should -Throw '*No template build found*'
    }
}

Describe 'Get-BicepDeploymentContext (per-customer)' -Tag 'L0', 'logic' {
    # Boundary mocked + config cache reset ONCE (see the devbox block's note); per-test only the build folder
    # is wiped.
    BeforeAll {
        # Own output root through the seam (see the devbox block's note).
        $script:sampleCustomerOutputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/deployment-context/template/sample-customer'
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/deployment-context'
        } -ModuleName Catzc.Azure.Templates

        Mock Build-Bicep {
            $outputFolder = (Get-BicepTemplate $Template).output_folder
            [System.IO.Directory]::CreateDirectory($outputFolder) | Out-Null
            foreach ($file in 'main.json', 'parameters.alpha.json', 'parameters.acme.alpha.json') {
                [System.IO.File]::WriteAllText((Join-Path $outputFolder $file), '{}')
            }
            $outputFolder
        } -ModuleName Catzc.Azure.Templates
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
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:sampleCustomerOutputRoot)) {
            [System.IO.Directory]::Delete($script:sampleCustomerOutputRoot, $true)
        }
    }

    AfterAll {
        if ($script:sampleCustomerOutputRoot -and (Test-Path $script:sampleCustomerOutputRoot)) {
            Remove-Item $script:sampleCustomerOutputRoot -Recurse -Force
        }
    }

    It 'a customer-subscription session targets the customer RG, artifact, and configuration/<customer>/ slot' {
        # The session (the service connection) is what selects the customer deployment.
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'acme_lower'; id = '00000000-0000-0000-0000-000000000005'; customer = 'acme'
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample-customer
        $context.deployment.resource_group | Should -Be 'alpha-weu-tst-scus-acme-rg'   # customer from the session subscription
        $context.deployment.name | Should -BeLike 'sample-customer-alpha-*'
        $context.environment.subscription.name | Should -Be 'acme_lower'
        $context.artifacts.parameters_file | Should -BeLike '*parameters.acme.alpha.json'
    }

    It 'a non-customer session targets the configuration-root slot + RG + artifact' {
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'core_lower'; id = '00000000-0000-0000-0000-000000000002'; customer = ''
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample-customer
        $context.deployment.resource_group | Should -Be 'alpha-weu-tst-scus-rg'   # no customer on core_lower
        $context.environment.subscription.name | Should -Be 'core_lower'
        $context.artifacts.parameters_file | Should -BeLike '*parameters.alpha.json'
    }

    It 'the -SubscriptionIdAssertIs guard throws when the session subscription differs' {
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'acme_lower'; id = '00000000-0000-0000-0000-000000000005'; customer = 'acme'
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates
        { Get-BicepDeploymentContext -Environment alpha -Template sample-customer -SubscriptionIdAssertIs '00000000-0000-0000-0000-000000000002' } |
            Should -Throw '*-SubscriptionIdAssertIs failed*'
    }

    It 'throws a self-contained error when the session addresses a coordinate the template has no config for' {
        # globex has no configuration/globex/ folder in sample-customer.
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'globex_short'; id = '00000000-0000-0000-0000-000000000007'; customer = 'globex'
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates
        { Get-BicepDeploymentContext -Environment alpha -Template sample-customer } |
            Should -Throw "*no config*customer 'globex'*"
    }
}

Describe 'Get-BicepDeploymentContext (pipeline)' -Tag 'L0', 'logic' {
    # Boundary mocked + config cache reset ONCE (see the devbox block's note). None of these tests mutate the
    # artifacts folder or the env vars, so the fixture folder and the pipeline-env stand-ins are set up once and
    # torn down once.
    BeforeAll {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Azure.Templates
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'core_lower'; id = '00000000-0000-0000-0000-000000000002'; customer = ''
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Build-Bicep { throw 'Build-Bicep must not be invoked on a pipeline agent' } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        $script:originalBuildId = $env:BUILD_BUILDID
        $script:originalCommit = $env:BUILD_SOURCEVERSION
        $env:BUILD_BUILDID = '99999'
        $env:BUILD_SOURCEVERSION = '1234567890abcdef1234567890abcdef12345678'

        $script:artifactsFolder = Join-Path ([IO.Path]::GetTempPath()) ('catzc-test-' + [Guid]::NewGuid())
        [System.IO.Directory]::CreateDirectory($script:artifactsFolder) | Out-Null
        foreach ($file in 'main.json', 'parameters.alpha.json') {
            [System.IO.File]::WriteAllText((Join-Path $script:artifactsFolder $file), '{}')
        }
    }

    AfterAll {
        $env:BUILD_BUILDID = $script:originalBuildId
        $env:BUILD_SOURCEVERSION = $script:originalCommit

        if ($script:artifactsFolder -and [System.IO.Directory]::Exists($script:artifactsFolder)) {
            [System.IO.Directory]::Delete($script:artifactsFolder, $true)
        }
    }

    It 'uses -ArtifactsFolder as the build folder without invoking Build-Bicep' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample -ArtifactsFolder $script:artifactsFolder
        $context.artifacts.did_local_build | Should -BeFalse
        $context.artifacts.folder | Should -Be $script:artifactsFolder
        Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 0
    }

    It 'rejects -DoNotRebuild in pipeline' {
        { Get-BicepDeploymentContext -Environment alpha -Template sample -ArtifactsFolder $script:artifactsFolder -DoNotRebuild } |
            Should -Throw '*devbox-only*'
    }

    It 'rejects -OverrideDoNotRunAndRun in pipeline' {
        { Get-BicepDeploymentContext -Environment alpha -Template sample -ArtifactsFolder $script:artifactsFolder -OverrideDoNotRunAndRun } |
            Should -Throw '*devbox-only*'
    }

    It 'requires -ArtifactsFolder in pipeline' {
        { Get-BicepDeploymentContext -Environment alpha -Template sample } |
            Should -Throw '*ArtifactsFolder*'
    }
}

Describe 'Get-BicepDeploymentContext (DoNotRun gate)' -Tag 'L0', 'logic' {
    # Boundary mocked + config cache reset ONCE (see the devbox block's note); per-test only the build folder
    # is wiped (one test builds into it).
    BeforeAll {
        # Own output root through the seam (see the devbox block's note).
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/test-isolation/deployment-context/template/sample'
        Mock Get-BicepTemplatesOutputRoot {
            Join-Path (Get-RepositoryRoot) 'out/test-isolation/deployment-context'
        } -ModuleName Catzc.Azure.Templates

        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        Mock Get-AzCliSessionSubscription {
            [ordered]@{ name = 'core_lower'; id = '00000000-0000-0000-0000-000000000002'; customer = ''
                tenant = [ordered]@{ name = 'fixtenant'; id = '00000000-0000-0000-0000-000000000001' }
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Stand in for a template whose options.yml declared deployment_mode: DoNotRun, but keep
        # the rest of the real 'sample' descriptor so full resolution (when overridden) still works.
        Mock Get-BicepTemplate {
            $real = (Get-BicepTemplates) | Where-Object { $_.name -eq 'sample' } | Select-Object -First 1
            # BicepTemplate is immutable (get-only) — reconstruct the DoNotRun variant via the ctor.
            [Catzc.Azure.Templates.BicepTemplate]::new([ordered]@{
                    name                 = $real.name
                    folder               = $real.folder
                    main                 = $real.main
                    bicep_files          = $real.bicep_files
                    configuration_folder = $real.configuration_folder
                    configuration_files  = $real.configuration_files
                    environments         = $real.environments
                    subscriptions        = $real.subscriptions
                    customers            = $real.customers
                    slots                = $real.slots
                    output_folder        = $real.output_folder
                    deployment_mode      = 'DoNotRun'
                    deployment_target    = $real.deployment_target
                    environment_kind     = $real.environment_kind
                    short_name           = $real.short_name
                    prepost_module       = $real.prepost_module
                    resources            = $real.resources
                })
        } -ModuleName Catzc.Azure.Templates

        Mock Build-Bicep {
            [System.IO.Directory]::CreateDirectory($script:outputRoot) | Out-Null
            foreach ($file in 'main.json', 'parameters.alpha.json') {
                [System.IO.File]::WriteAllText((Join-Path $script:outputRoot $file), '{}')
            }
            $script:outputRoot
        } -ModuleName Catzc.Azure.Templates
    }

    AfterEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    It 'returns $null (skip signal) without building' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample
        $context | Should -BeNullOrEmpty
        Should -Invoke Build-Bicep -ModuleName Catzc.Azure.Templates -Times 0
    }

    It 'returns the context when -OverrideDoNotRunAndRun bypasses the gate' {
        $context = Get-BicepDeploymentContext -Environment alpha -Template sample -OverrideDoNotRunAndRun
        $context | Should -Not -BeNullOrEmpty
        $context.deployment.mode | Should -Be 'DoNotRun'
    }
}
