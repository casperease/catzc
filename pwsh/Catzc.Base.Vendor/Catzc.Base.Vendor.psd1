@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-VendorModuleAvailable', 'Install-VendorModule', 'Remove-VendorModules', 'Test-VendorModuleAvailable')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-VendoredModule.ps1', 'private/Resolve-VendorRepository.ps1', 'Assert-VendorModuleAvailable.ps1', 'Install-VendorModule.ps1', 'Remove-VendorModules.ps1', 'Test-VendorModuleAvailable.ps1') }
}
