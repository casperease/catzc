Describe 'Get-AzureBicepEnvironmentKinds' -Tag 'L0', 'logic' {
    It 'returns standard and subscription' {
        $kinds = Get-AzureBicepEnvironmentKinds
        $kinds | Should -Contain 'standard'
        $kinds | Should -Contain 'subscription'
    }

    It 'returns exactly 2 items' {
        @(Get-AzureBicepEnvironmentKinds).Count | Should -Be 2
    }
}
