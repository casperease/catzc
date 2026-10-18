@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Import-RepositoryWithHistory', 'New-GitIgnore', 'New-RepositorySnapshot', 'Push-Dirty', 'Remove-RepositorySnapshot', 'Reset-GitCleanFxd', 'Test-RepositorySnapshot')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Format-GitIgnoreSection.ps1', 'private/Get-AutoControlledGlobs.ps1', 'Import-RepositoryWithHistory.ps1', 'New-GitIgnore.ps1', 'New-RepositorySnapshot.ps1', 'Push-Dirty.ps1', 'Remove-RepositorySnapshot.ps1', 'Reset-GitCleanFxd.ps1', 'Test-RepositorySnapshot.ps1') }
}
