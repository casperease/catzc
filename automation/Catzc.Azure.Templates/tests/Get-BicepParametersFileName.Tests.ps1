Describe 'Get-BicepParametersFileName' -Tag 'L0', 'logic' {
    It 'names the artifact by subscription and config (parameters.SUBSCRIPTION.CONFIG.json)' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Subscription shared_nonprod } |
            Should -Be 'parameters.shared_nonprod.dev.json'
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Slot 001 -Subscription shared_nonprod } |
            Should -Be 'parameters.shared_nonprod.dev-001.json'
    }

    It 'keys distinct subscriptions to distinct artifact names for the same env+slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Subscription apex_nonprod } |
            Should -Be 'parameters.apex_nonprod.dev.json'
    }
}
