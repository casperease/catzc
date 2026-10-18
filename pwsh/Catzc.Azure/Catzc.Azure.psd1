@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Get-AzureBicepMinVersion', 'Get-AzureCustomer', 'Get-AzureCustomers', 'Get-AzureEnvironment', 'Get-AzureSubscription', 'Get-AzureSubscriptionCustomer', 'Get-AzureSubscriptionEnvironment', 'Test-AzureNetworkPlan')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-NetworkPlanViolations.ps1', 'Get-AzureBicepMinVersion.ps1', 'Get-AzureCustomer.ps1', 'Get-AzureCustomers.ps1', 'Get-AzureEnvironment.ps1', 'Get-AzureSubscription.ps1', 'Get-AzureSubscriptionCustomer.ps1', 'Get-AzureSubscriptionEnvironment.ps1', 'Test-AzureNetworkPlan.ps1') }
}
