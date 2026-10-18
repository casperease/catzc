@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-CatzcBundle', 'Build-Modules', 'Export-Catzc', 'Get-CatzcContentHash', 'Install-Catzc', 'Resolve-CatzcBuildVersion')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Assert-BundleFootprint.ps1', 'private/Get-CatzcUserModulePath.ps1', 'private/New-CatzcNuGetPackage.ps1', 'Assert-CatzcBundle.ps1', 'Build-Modules.ps1', 'Export-Catzc.ps1', 'Get-CatzcContentHash.ps1', 'Install-Catzc.ps1', 'Resolve-CatzcBuildVersion.ps1') }
}
