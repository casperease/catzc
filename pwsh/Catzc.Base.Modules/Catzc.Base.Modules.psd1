@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Get-Aspect', 'Get-CatzcModule', 'Test-AspectDeclaration')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-PlaceModuleEntry.ps1', 'Get-Aspect.ps1', 'Get-CatzcModule.ps1', 'Test-AspectDeclaration.ps1') }
}
