<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/tests/Test-AzCliSubscriptionAccessible.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Cli
    relatives:
      source: automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
---
#>

Describe 'Test-AzCliSubscriptionAccessible' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '50a0ed00-de00-50b0-0000-000000000000'
    }

    It 'returns $true when the scoped ARM probe succeeds' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }

        Test-AzCliSubscriptionAccessible -SubscriptionId $script:sub | Should -BeTrue
    }

    It 'returns $false when the probe fails (never throws)' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = 'AuthorizationFailed'; ExitCode = 1 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account list-locations*' }
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; Errors = ''; ExitCode = 0 } } `
            -ModuleName Catzc.Azure.Cli -ParameterFilter { $Arguments -like 'account show*' }

        Test-AzCliSubscriptionAccessible -SubscriptionId $script:sub | Should -BeFalse
    }
}
