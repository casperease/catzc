@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Format-MarkdownMetaBlock', 'Get-MarkdownMetaState', 'Remove-MarkdownFrontMatter')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Format-MarkdownMetaBlock.ps1', 'Get-MarkdownMetaState.ps1', 'Remove-MarkdownFrontMatter.ps1') }
}
