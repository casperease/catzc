@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-FileIsLocked', 'Assert-FileIsNotLocked', 'Copy-Directory', 'Get-FileLockingProcess', 'Get-GitChangedPath', 'Get-GitCurrentBranch', 'Get-GitCurrentCommit', 'Get-GitTrackedPath', 'Get-InputStamp', 'Get-RepoStatus', 'Invoke-GitCommit', 'Set-FileLink', 'Test-FileIsLocked', 'Test-FileIsNotLocked', 'Test-GitPathChanged', 'Write-FileIfChanged')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-GitIndexPath.ps1', 'Assert-FileIsLocked.ps1', 'Assert-FileIsNotLocked.ps1', 'Copy-Directory.ps1', 'Get-FileLockingProcess.ps1', 'Get-GitChangedPath.ps1', 'Get-GitCurrentBranch.ps1', 'Get-GitCurrentCommit.ps1', 'Get-GitTrackedPath.ps1', 'Get-InputStamp.ps1', 'Get-RepoStatus.ps1', 'Invoke-GitCommit.ps1', 'Set-FileLink.ps1', 'Test-FileIsLocked.ps1', 'Test-FileIsNotLocked.ps1', 'Test-GitPathChanged.ps1', 'Write-FileIfChanged.ps1') }
}
