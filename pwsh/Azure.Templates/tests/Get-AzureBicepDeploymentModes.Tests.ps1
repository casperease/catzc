Describe 'Get-AzureBicepDeploymentModes' -Tag 'L0', 'logic' {
    It 'returns Incremental, Complete, DoNotRun' {
        $modes = Get-AzureBicepDeploymentModes
        $modes | Should -Contain 'Incremental'
        $modes | Should -Contain 'Complete'
        $modes | Should -Contain 'DoNotRun'
    }

    It 'returns exactly 3 items' {
        @(Get-AzureBicepDeploymentModes).Count | Should -Be 3
    }
}
