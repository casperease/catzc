@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Format-CodeMetaHead', 'Format-PropertyMetaHead', 'Get-CodeMetaState', 'Get-PropertyMetaState')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Format-CodeMetaHead.ps1', 'Format-PropertyMetaHead.ps1', 'Get-CodeMetaState.ps1', 'Get-PropertyMetaState.ps1') }
}
