@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Build-RootConfig', 'New-GitAttributes', 'Test-RootAnalyzerSettings', 'Test-RootConfigFiles')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-RootConfigInputStamp.ps1', 'private/Get-RootConfigRenderedFile.ps1', 'private/Get-RootConfigTargets.ps1', 'private/Invoke-RootConfigGenerator.ps1', 'Build-RootConfig.ps1', 'New-GitAttributes.ps1', 'Test-RootAnalyzerSettings.ps1', 'Test-RootConfigFiles.ps1') }
}
