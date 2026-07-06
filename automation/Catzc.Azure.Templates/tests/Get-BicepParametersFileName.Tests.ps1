Describe 'Get-BicepParametersFileName' -Tag 'L0', 'logic' {
    It 'names a configuration-root artifact by config alone (parameters.CONFIG.json)' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev } |
            Should -Be 'parameters.dev.json'
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Slot 001 } |
            Should -Be 'parameters.dev-001.json'
    }

    It 'names a customer artifact by customer and config (parameters.CUSTOMER.CONFIG.json)' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Customer acme } |
            Should -Be 'parameters.acme.dev.json'
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Slot 001 -Customer acme } |
            Should -Be 'parameters.acme.dev-001.json'
    }

    It 'keys distinct customers to distinct artifact names for the same env+slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment dev -Customer globex } |
            Should -Be 'parameters.globex.dev.json'
    }
}
