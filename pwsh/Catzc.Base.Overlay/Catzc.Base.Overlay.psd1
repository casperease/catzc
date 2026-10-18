@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-CatzcOverlay', 'Get-CatzcOverlay', 'Get-FunctionFileViolation', 'Import-CatzcOverlay')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-LocalModuleViolation.ps1', 'private/Get-OverlayContractViolation.ps1', 'Assert-CatzcOverlay.ps1', 'Get-CatzcOverlay.ps1', 'Get-FunctionFileViolation.ps1', 'Import-CatzcOverlay.ps1') }
}
