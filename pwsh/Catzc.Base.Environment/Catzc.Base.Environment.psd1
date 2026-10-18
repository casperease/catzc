@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Add-PermanentPath', 'Get-EnvironmentPath', 'Get-PermanentEnvironmentVariable', 'Remove-PermanentPath', 'Set-EnvironmentPath', 'Set-PermanentEnvironmentVariable', 'Sync-SessionPath')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Add-PermanentPath.ps1', 'Get-EnvironmentPath.ps1', 'Get-PermanentEnvironmentVariable.ps1', 'Remove-PermanentPath.ps1', 'Set-EnvironmentPath.ps1', 'Set-PermanentEnvironmentVariable.ps1', 'Sync-SessionPath.ps1') }
}
