@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Install-Cspell', 'Install-Markdownlint', 'Install-NodeJs', 'Install-Prettier', 'Invoke-Npm', 'Remove-NodeJs', 'Uninstall-Cspell', 'Uninstall-Markdownlint', 'Uninstall-NodeJs', 'Uninstall-Prettier')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('Install-Cspell.ps1', 'Install-Markdownlint.ps1', 'Install-NodeJs.ps1', 'Install-Prettier.ps1', 'Invoke-Npm.ps1', 'Remove-NodeJs.ps1', 'Uninstall-Cspell.ps1', 'Uninstall-Markdownlint.ps1', 'Uninstall-NodeJs.ps1', 'Uninstall-Prettier.ps1') }
}
