Describe 'Get-AzCliSubscriptionAccessState' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '50a0ed00-de00-50b0-0000-000000000000'
    }

    It 'reports accessible when the scoped ARM probe exits zero' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }

        $state = Get-AzCliSubscriptionAccessState -SubscriptionId $script:sub
        $state.logged_in | Should -BeTrue
        $state.accessible | Should -BeTrue
        $state.subscription | Should -Be $script:sub
    }

    It 'does not run the local fallback read when the probe succeeds' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }

        Get-AzCliSubscriptionAccessState -SubscriptionId $script:sub | Out-Null

        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Cli -Times 0 -ParameterFilter { $Arguments -like 'account show*' }
    }

    It 'is accessible=false but logged_in=true when the probe fails and account show succeeds' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = 'AuthorizationFailed'; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account show*' }

        $state = Get-AzCliSubscriptionAccessState -SubscriptionId $script:sub
        $state.logged_in | Should -BeTrue
        $state.accessible | Should -BeFalse
    }

    It 'is accessible=false and logged_in=false when both the probe and account show fail' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = 'Please run az login'; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account show*' }

        $state = Get-AzCliSubscriptionAccessState -SubscriptionId $script:sub
        $state.logged_in | Should -BeFalse
        $state.accessible | Should -BeFalse
    }
}
