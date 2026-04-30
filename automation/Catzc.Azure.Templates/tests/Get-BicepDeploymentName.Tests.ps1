Describe 'Get-BicepDeploymentName' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
    }

    Context 'devbox' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
        }

        It 'composes Template-slotName-xCLIxx-xxxxxxx with placeholder buildId/commit' {
            Get-BicepDeploymentName sample -Environment alpha | Should -Be 'sample-alpha-xCLIxx-xxxxxxx'
        }

        It 'includes the slot in the deployment name' {
            Get-BicepDeploymentName sample -Environment alpha -Slot 001 | Should -Be 'sample-alpha-001-xCLIxx-xxxxxxx'
        }

        It 'does not encode the subscription/customer (names are per-subscription-scoped)' {
            Get-BicepDeploymentName sample-customer -Environment alpha | Should -Be 'sample-customer-alpha-xCLIxx-xxxxxxx'
        }
    }

    # Get-BicepDeploymentName picks the platform by which run-id DATA var is present (GITHUB_RUN_ID → GitHub
    # Actions, else Azure DevOps). Each case sets its own vars and clears the other's run-id — important
    # because these tests themselves run on a GitHub Actions runner where $env:GITHUB_RUN_ID is already set.
    Context 'pipeline (Azure DevOps)' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Azure.Templates
            $script:saved = @{ R = $env:GITHUB_RUN_ID; S = $env:GITHUB_SHA; A = $env:BUILD_BUILDID; B = $env:BUILD_SOURCEVERSION }
            $env:GITHUB_RUN_ID = $null   # absent → ADO branch (cleared because the runner sets it)
            $env:GITHUB_SHA = $null
            $env:BUILD_BUILDID = '12345'
            $env:BUILD_SOURCEVERSION = 'abcdef1234567890abcdef1234567890abcdef12'
        }

        AfterEach {
            $env:GITHUB_RUN_ID = $script:saved.R; $env:GITHUB_SHA = $script:saved.S
            $env:BUILD_BUILDID = $script:saved.A; $env:BUILD_SOURCEVERSION = $script:saved.B
        }

        It 'composes Template-slotName-buildId-shortCommit using ADO env vars' {
            Get-BicepDeploymentName sample -Environment alpha | Should -Be 'sample-alpha-12345-abcdef1'
        }
    }

    Context 'pipeline (GitHub Actions)' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Azure.Templates
            $script:saved = @{ R = $env:GITHUB_RUN_ID; S = $env:GITHUB_SHA }
            $env:GITHUB_RUN_ID = '987654'
            $env:GITHUB_SHA = 'fedcba9876543210fedcba9876543210fedcba98'
        }

        AfterEach {
            $env:GITHUB_RUN_ID = $script:saved.R; $env:GITHUB_SHA = $script:saved.S
        }

        It 'composes Template-slotName-runId-shortSha using GitHub Actions env vars' {
            Get-BicepDeploymentName sample -Environment alpha | Should -Be 'sample-alpha-987654-fedcba9'
        }
    }

    It 'rejects an unknown template via ValidateScript' {
        { Get-BicepDeploymentName nonexistent -Environment alpha } | Should -Throw
    }
}
