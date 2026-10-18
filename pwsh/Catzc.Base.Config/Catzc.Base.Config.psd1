@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Get-Config', 'Get-ConfigValue')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-ConfigOverlayRoot.ps1', 'private/Get-ConfigRegistry.ps1', 'private/Merge-ConfigFragment.ps1', 'private/Resolve-ConfigEntry.ps1', 'private/Resolve-ConfigKeyPath.ps1', 'Get-Config.ps1', 'Get-ConfigValue.ps1') }
}
