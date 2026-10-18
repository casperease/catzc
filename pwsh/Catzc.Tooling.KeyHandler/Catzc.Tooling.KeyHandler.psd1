@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Import-PSReadLineKeyHandlerSet', 'Save-PSReadLineKeyHandlerSet')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Select-SupportedKeyHandler.ps1', 'Import-PSReadLineKeyHandlerSet.ps1', 'Save-PSReadLineKeyHandlerSet.ps1') }
}
