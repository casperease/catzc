@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('ConvertTo-ModuleDependencyDiagram', 'Copy-CatzcModule', 'Get-FunctionDependency', 'Get-FunctionDependencyTree', 'Get-InternalAssetDependency', 'Get-ModuleDependency', 'Get-ModuleDependencyEdges', 'Get-ModuleFunction', 'Get-ModuleOrder', 'Get-ModuleProfile', 'New-Importer', 'Sync-GeneratedFile', 'Test-CheckedInBinaries', 'Test-FolderConventions', 'Test-FunctionDependency', 'Test-InternalAssetDependency', 'Test-ModuleCycles', 'Test-ModuleDependency')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-ModuleDependencyClosure.ps1', 'private/Get-ModuleDependencyConfig.ps1', 'private/Get-ModuleDependencyMap.ps1', 'private/Get-ModuleDependencyViolations.ps1', 'private/Get-ModuleGroupConfig.ps1', 'private/Get-UncoveredInternalAssetDependency.ps1', 'ConvertTo-ModuleDependencyDiagram.ps1', 'Copy-CatzcModule.ps1', 'Get-FunctionDependency.ps1', 'Get-FunctionDependencyTree.ps1', 'Get-InternalAssetDependency.ps1', 'Get-ModuleDependency.ps1', 'Get-ModuleDependencyEdges.ps1', 'Get-ModuleFunction.ps1', 'Get-ModuleOrder.ps1', 'Get-ModuleProfile.ps1', 'New-Importer.ps1', 'Sync-GeneratedFile.ps1', 'Test-CheckedInBinaries.ps1', 'Test-FolderConventions.ps1', 'Test-FunctionDependency.ps1', 'Test-InternalAssetDependency.ps1', 'Test-ModuleCycles.ps1', 'Test-ModuleDependency.ps1') }
}
