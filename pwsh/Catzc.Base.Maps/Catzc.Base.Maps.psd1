@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Export-WorldMapPdf', 'Get-ValueChainHighlight', 'Get-ValueChainMap', 'Get-WorldMap', 'Get-WorldMapHighlight', 'Test-ValueChainMap', 'Test-WorldMap')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-WorldMapOutputRoot.ps1', 'private/Resolve-MapLabelTerm.ps1', 'Export-WorldMapPdf.ps1', 'Get-ValueChainHighlight.ps1', 'Get-ValueChainMap.ps1', 'Get-WorldMap.ps1', 'Get-WorldMapHighlight.ps1', 'Test-ValueChainMap.ps1', 'Test-WorldMap.ps1') }
}
