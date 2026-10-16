<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/tests/Assert-AzCliSubscriptionAccessible.Tests.ps1
    folder: tests
    name: assert-az-cli-subscription-accessible-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Assert-AzCliSubscriptionAccessible' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '50a0ed00-de00-50b0-0000-000000000000'
    }

    It 'does not throw when the subscription is accessible' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }

        { Assert-AzCliSubscriptionAccessible -SubscriptionId $script:sub } | Should -Not -Throw
    }

    It 'throws with an az login hint when not logged in' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = 'Please run az login'; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account show*' }

        { Assert-AzCliSubscriptionAccessible -SubscriptionId $script:sub } | Should -Throw '*az login*'
    }

    It 'throws naming the subscription when logged in but it cannot be reached' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = 'AuthorizationFailed'; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account show*' }

        { Assert-AzCliSubscriptionAccessible -SubscriptionId $script:sub } | Should -Throw '*cannot access subscription*'
    }
}
