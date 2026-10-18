@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Convert-FirewallCsvToMarkdown', 'Convert-FirewallCsvToYaml', 'Get-FirewallCsv', 'Get-FirewallIpgsYaml')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-FirewallMarkdownColumns.ps1', 'private/Get-FirewallMarkdownTable.ps1', 'Convert-FirewallCsvToMarkdown.ps1', 'Convert-FirewallCsvToYaml.ps1', 'Get-FirewallCsv.ps1', 'Get-FirewallIpgsYaml.ps1') }
}
