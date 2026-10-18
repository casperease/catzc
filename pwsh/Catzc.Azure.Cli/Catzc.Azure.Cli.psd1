@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-AzCliBicep', 'Assert-AzCliCanAccess', 'Assert-AzCliConnected', 'Assert-AzCliExtension', 'Assert-AzCliIsConnected', 'Assert-AzCliSubscriptionAccessible', 'Connect-AzCli', 'Disconnect-AzCli', 'Get-AzCliConnectionState', 'Get-AzCliSessionSubscription', 'Get-AzCliSubscriptionAccessState', 'Get-CurrentAzSubscription', 'Install-AzCliBicep', 'Invoke-AzCli', 'Invoke-InSubscription', 'Set-AzCliSubscription', 'Set-CurrentAzSubscription', 'Test-AzCliBicep', 'Test-AzCliCanAccess', 'Test-AzCliConnected', 'Test-AzCliExtension', 'Test-AzCliIsConnected', 'Test-AzCliSubscriptionAccessible')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-AzCliBicepState.ps1', 'Assert-AzCliBicep.ps1', 'Assert-AzCliCanAccess.ps1', 'Assert-AzCliConnected.ps1', 'Assert-AzCliExtension.ps1', 'Assert-AzCliIsConnected.ps1', 'Assert-AzCliSubscriptionAccessible.ps1', 'Connect-AzCli.ps1', 'Disconnect-AzCli.ps1', 'Get-AzCliConnectionState.ps1', 'Get-AzCliSessionSubscription.ps1', 'Get-AzCliSubscriptionAccessState.ps1', 'Get-CurrentAzSubscription.ps1', 'Install-AzCliBicep.ps1', 'Invoke-AzCli.ps1', 'Invoke-InSubscription.ps1', 'Set-AzCliSubscription.ps1', 'Set-CurrentAzSubscription.ps1', 'Test-AzCliBicep.ps1', 'Test-AzCliCanAccess.ps1', 'Test-AzCliConnected.ps1', 'Test-AzCliExtension.ps1', 'Test-AzCliIsConnected.ps1', 'Test-AzCliSubscriptionAccessible.ps1') }
}
