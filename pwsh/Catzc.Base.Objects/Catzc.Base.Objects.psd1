@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('ConvertTo-FlatSettingSet', 'ConvertTo-SortedDictionary', 'ConvertTo-YamlSafe', 'Copy-Object')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Expand-ObjectProperties.ps1', 'ConvertTo-FlatSettingSet.ps1', 'ConvertTo-SortedDictionary.ps1', 'ConvertTo-YamlSafe.ps1', 'Copy-Object.ps1') }
}
