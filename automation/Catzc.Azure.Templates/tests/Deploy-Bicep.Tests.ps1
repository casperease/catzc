Describe 'Deploy-Bicep' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:tempArtifacts = Join-Path ([IO.Path]::GetTempPath()) ('catzc-deploy-' + [Guid]::NewGuid())

        # Static fixtures + boundary mocks set up ONCE (not per test). The only per-test state is the hook
        # marker files (pre-/post-called.json), cleared in BeforeEach; main.json/parameters/PrePost.psm1 never
        # change, so rebuilding them every test was pure filesystem-cmdlet tax (~5 cmdlet calls × ~20ms —
        # ADR-TEST:18). [System.IO] writes them in ~0.1ms.
        [System.IO.Directory]::CreateDirectory($script:tempArtifacts) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:tempArtifacts 'main.json'), '{}')
        [System.IO.File]::WriteAllText((Join-Path $script:tempArtifacts 'parameters.alpha.json'), '{}')

        # A real per-template PrePost.psm1 fixture. Under the current model there is NO default hook
        # loaded from assets — Deploy-Bicep runs only the hooks a template's own PrePost.psm1 exports.
        # These hooks record what they were called with to marker files, so the tests assert the
        # template's own hooks actually ran (and with the right context).
        $prepostContent = @'
function Invoke-BicepPreDeploy {
    param($DeployInvocation, $TemplateDescriptor, $ConfigurationDescriptor, $EnvironmentDescriptor, [switch]$DryRun)
    @{ mode = $DeployInvocation.Mode; environment = $DeployInvocation.Environment; dryRun = [bool]$DryRun; hasTemplate = [bool]$TemplateDescriptor; hasEnv = [bool]$EnvironmentDescriptor; hasConfig = [bool]$ConfigurationDescriptor } |
        ConvertTo-Json | Set-Content (Join-Path $PSScriptRoot 'pre-called.json')
}
function Invoke-BicepPostDeploy {
    param($DeployInvocation, $TemplateDescriptor, $ConfigurationDescriptor, $EnvironmentDescriptor, $DeploymentOutput)
    @{ hasOutput = [bool]$DeploymentOutput } | ConvertTo-Json | Set-Content (Join-Path $PSScriptRoot 'post-called.json')
}
'@
        [System.IO.File]::WriteAllText((Join-Path $script:tempArtifacts 'PrePost.psm1'), $prepostContent)

        # Reset $configCache ONCE (not per test): the mocked config is the same fixture azure.yml every test,
        # so a per-test clear only forced a needless cold re-parse (~65ms/test). Dropped once here so any
        # real-config entry from a prior test file is gone; the fixture config then stays warm.
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # These exercise the DEVBOX path; without this, the real Test-IsRunningInPipeline returns $true under
        # CI ($env:GITHUB_ACTIONS) and Deploy-Bicep throws "requires -SubscriptionIdAssertIs in a pipeline".
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        Mock Deploy-AzureResourceGroup {
            [ordered]@{ name = $ResourceGroup; provisioning_state = 'Skipped' }
        } -ModuleName Catzc.Azure.Templates
        Mock Set-BicepTrackingTagSet { } -ModuleName Catzc.Azure.Templates

        # Successful deployment output
        Mock Invoke-AzCli {
            [pscustomobject]@{
                Output   = "properties:`n  provisioningState: Succeeded`n  outputs:`n    storageAccountId:`n      value: /subscriptions/x/resourceGroups/y/providers/Microsoft.Storage/storageAccounts/z"
                ExitCode = 0
            }
        } -ModuleName Catzc.Azure.Templates

        # Synthetic deployment context (avoids Build-Bicep dependency); points at the fixture PrePost.
        $tempFolder = $script:tempArtifacts
        Mock Get-BicepDeploymentContext {
            [ordered]@{
                template    = 'sample'
                deployment  = [ordered]@{
                    name           = 'sample-CLI-test'
                    mode           = 'Incremental'
                    target         = 'ResourceGroup'
                    resource_group = 'rg-sample-alpha'
                }
                artifacts   = [ordered]@{
                    did_local_build = $true
                    folder          = $tempFolder
                    template_file   = (Join-Path $tempFolder 'main.json')
                    parameters_file = (Join-Path $tempFolder 'parameters.alpha.json')
                    prepost_module  = (Join-Path $tempFolder 'PrePost.psm1')
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
    }

    BeforeEach {
        # Clear ONLY the hook marker files so each test starts clean — the hooks write these, and several
        # tests assert a marker is absent (DryRun skips PostDeploy; DoNotRun runs no hooks).
        foreach ($m in 'pre-called.json', 'post-called.json') {
            $p = Join-Path $script:tempArtifacts $m
            if ([System.IO.File]::Exists($p)) {
                [System.IO.File]::Delete($p)
            }
        }
    }

    AfterAll {
        if ([System.IO.Directory]::Exists($script:tempArtifacts)) {
            [System.IO.Directory]::Delete($script:tempArtifacts, $true)
        }
    }

    It 'passes -SubscriptionIdAssertIs through to the deployment context (the guard lives there)' {
        Deploy-Bicep alpha sample -SubscriptionIdAssertIs '50a0ed00-de00-50b0-0000-000000000000'
        Should -Invoke Get-BicepDeploymentContext -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $SubscriptionIdAssertIs -eq '50a0ed00-de00-50b0-0000-000000000000'
        }
    }

    It 'runs the template PreDeploy hook with DeployInvocation + TemplateDescriptor/EnvironmentDescriptor/ConfigurationDescriptor' {
        Deploy-Bicep alpha sample
        $marker = Join-Path $script:tempArtifacts 'pre-called.json'
        $marker | Should -Exist
        $rec = Get-Content $marker -Raw | ConvertFrom-Json
        $rec.mode | Should -Be 'Incremental'
        $rec.environment | Should -Be 'alpha'
        $rec.dryRun | Should -BeFalse
        $rec.hasTemplate | Should -BeTrue
        $rec.hasEnv | Should -BeTrue
        $rec.hasConfig | Should -BeTrue
    }

    It 'ensures the resource group exists in the context subscription (no re-resolve — B1 fix)' {
        Deploy-Bicep alpha sample
        Should -Invoke Deploy-AzureResourceGroup -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $ResourceGroup -eq 'rg-sample-alpha' -and
            $SubscriptionId -eq '50a0ed00-de00-50b0-0000-000000000000' -and
            $Region -eq 'westeurope'
        }
    }

    It 'invokes az deployment group create with the resolved args' {
        Deploy-Bicep alpha sample
        $expectedTemplate = [regex]::Escape("--template-file `"$(Join-Path $script:tempArtifacts 'main.json')`"")
        $expectedParams = [regex]::Escape("--parameters `"@$(Join-Path $script:tempArtifacts 'parameters.alpha.json')`"")
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $Arguments -match '^deployment group create' -and
            $Arguments -match '--name "sample-CLI-test"' -and
            $Arguments -match '--resource-group rg-sample-alpha' -and
            $Arguments -match '--mode Incremental' -and
            $Arguments -match $expectedTemplate -and
            $Arguments -match $expectedParams -and
            $Arguments -notmatch '--what-if'
        }
    }

    It 'passes absolute --template-file / --parameters paths (no CWD dependence)' {
        Deploy-Bicep alpha sample
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $Arguments -match '--template-file "([^"]+)"' -and [IO.Path]::IsPathRooted($Matches[1]) -and
            $Arguments -match '--parameters "@([^"]+)"' -and [IO.Path]::IsPathRooted($Matches[1])
        }
    }

    It 'runs the template PostDeploy hook on success with DeploymentOutput' {
        Deploy-Bicep alpha sample
        $marker = Join-Path $script:tempArtifacts 'post-called.json'
        $marker | Should -Exist
        (Get-Content $marker -Raw | ConvertFrom-Json).hasOutput | Should -BeTrue
    }

    It 'sets tracking tags on success' {
        Deploy-Bicep alpha sample
        Should -Invoke Set-BicepTrackingTagSet -ModuleName Catzc.Azure.Templates -ParameterFilter {
            $Environment -eq 'alpha' -and $Template -eq 'sample'
        }
    }

    It 'surfaces the command, exit code, and az stderr when the deployment call fails' {
        Mock Invoke-AzCli {
            [pscustomobject]@{
                Output   = ''
                Errors   = "RequestDisallowedByPolicy: Resource 'x' was disallowed by policy."
                ExitCode = 1
            }
        } -ModuleName Catzc.Azure.Templates

        $err = { Deploy-Bicep alpha sample } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*Deployment 'sample-CLI-test' failed*"
        $err.Exception.Message | Should -BeLike '*exited 1*'
        $err.Exception.Message | Should -BeLike '*az deployment group create*'
        $err.Exception.Message | Should -BeLike '*RequestDisallowedByPolicy*'
    }

    It 'surfaces failures from the --what-if preview too' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = ''; Errors = 'InvalidTemplate: deployment validation failed'; ExitCode = 1 }
        } -ModuleName Catzc.Azure.Templates

        $err = { Deploy-Bicep alpha sample -DryRun } | Should -Throw -PassThru
        $err.Exception.Message | Should -BeLike "*What-if preview for 'sample-CLI-test' failed*"
        $err.Exception.Message | Should -BeLike '*InvalidTemplate*'
        $err.Exception.Message | Should -BeLike '*--what-if*'
    }

    It 'throws when provisioningState is not Succeeded' {
        Mock Invoke-AzCli {
            [pscustomobject]@{
                Output   = "properties:`n  provisioningState: Failed"
                ExitCode = 0
            }
        } -ModuleName Catzc.Azure.Templates

        { Deploy-Bicep alpha sample } | Should -Throw '*did not succeed*'
    }

    Context '-DryRun' {
        It 'runs the Azure --what-if preview instead of the real deployment' {
            Deploy-Bicep alpha sample -DryRun
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
                $Arguments -match 'deployment group create' -and $Arguments -match '--what-if'
            }
        }

        It 'does not run the PostDeploy hook or set tags' {
            Deploy-Bicep alpha sample -DryRun
            (Join-Path $script:tempArtifacts 'post-called.json') | Should -Not -Exist
            Should -Invoke Set-BicepTrackingTagSet -ModuleName Catzc.Azure.Templates -Times 0
        }

        It 'passes -DryRun to the PreDeploy hook' {
            Deploy-Bicep alpha sample -DryRun
            $rec = Get-Content (Join-Path $script:tempArtifacts 'pre-called.json') -Raw | ConvertFrom-Json
            $rec.dryRun | Should -BeTrue
        }
    }

    Context 'DoNotRun mode' {
        BeforeEach {
            Mock Get-BicepDeploymentContext { $null } -ModuleName Catzc.Azure.Templates
        }

        It 'returns early without calling az or running hooks' {
            Deploy-Bicep alpha sample
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 0
            (Join-Path $script:tempArtifacts 'pre-called.json') | Should -Not -Exist
            Should -Invoke Set-BicepTrackingTagSet -ModuleName Catzc.Azure.Templates -Times 0
        }
    }

    Context 'pipeline requires the explicit -SubscriptionIdAssertIs guard' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Azure.Templates
        }

        It 'throws when -SubscriptionIdAssertIs is omitted in a pipeline (the target must be pinned)' {
            { Deploy-Bicep alpha sample } | Should -Throw '*requires -SubscriptionIdAssertIs in a pipeline*'
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 0
        }

        It 'proceeds when -SubscriptionIdAssertIs is given in a pipeline' {
            { Deploy-Bicep alpha sample -SubscriptionIdAssertIs '50a0ed00-de00-50b0-0000-000000000000' } | Should -Not -Throw
        }
    }
}
