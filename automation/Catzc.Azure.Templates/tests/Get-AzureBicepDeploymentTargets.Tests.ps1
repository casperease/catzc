Describe 'Get-AzureBicepDeploymentTargets' -Tag 'L0', 'logic' {
    It 'returns Subscription and ResourceGroup' {
        $targets = Get-AzureBicepDeploymentTargets
        $targets | Should -Contain 'Subscription'
        $targets | Should -Contain 'ResourceGroup'
    }

    It 'returns exactly 2 items' {
        @(Get-AzureBicepDeploymentTargets).Count | Should -Be 2
    }
}
