@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Get-AdoBuildValidations', 'Register-AdoBuildValidation', 'Sync-AdoBuildValidations', 'Unregister-AdoBuildValidation')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-BuildValidationPathFilter.ps1', 'private/Resolve-AdoBuildValidationContext.ps1', 'Get-AdoBuildValidations.ps1', 'Register-AdoBuildValidation.ps1', 'Sync-AdoBuildValidations.ps1', 'Unregister-AdoBuildValidation.ps1') }
}
