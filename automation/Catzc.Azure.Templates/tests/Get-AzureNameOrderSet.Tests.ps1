Describe 'Get-AzureNameOrderSet' -Tag 'L0', 'logic' {
    It 'exposes the standard and classic orders' {
        $orders = Get-AzureNameOrderSet
        $orders.Contains('standard') | Should -BeTrue
        $orders.Contains('classic') | Should -BeTrue
    }

    It 'standard leads with env then slot as separate segments' {
        (Get-AzureNameOrderSet).standard[0] | Should -Be @('env')
        (Get-AzureNameOrderSet).standard[1] | Should -Be @('slot')
    }

    It 'classic leads with the type segment' {
        (Get-AzureNameOrderSet).classic[0] | Should -Be @('type')
    }
}
