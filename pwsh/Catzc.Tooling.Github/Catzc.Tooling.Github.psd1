@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-GitHubPurgeReady', 'New-SyntheticHistory', 'Publish-CleanHistory', 'Remove-TokenFromHistory', 'Reset-GitHubRepository', 'Test-GitHistoryClean')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Assert-RemoteMatchesBranch.ps1', 'Assert-GitHubPurgeReady.ps1', 'New-SyntheticHistory.ps1', 'Publish-CleanHistory.ps1', 'Remove-TokenFromHistory.ps1', 'Reset-GitHubRepository.ps1', 'Test-GitHistoryClean.ps1') }
}
