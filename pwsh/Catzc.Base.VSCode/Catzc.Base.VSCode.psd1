@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Build-VSCodeExtension', 'Install-VSCodeExtension', 'New-VSCodeExtensions', 'New-VSCodeLaunch', 'New-VSCodePipelineSchema', 'New-VSCodeSettings', 'New-VSCodeTasks')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/New-VSCodeExtensionFolder.ps1', 'Build-VSCodeExtension.ps1', 'Install-VSCodeExtension.ps1', 'New-VSCodeExtensions.ps1', 'New-VSCodeLaunch.ps1', 'New-VSCodePipelineSchema.ps1', 'New-VSCodeSettings.ps1', 'New-VSCodeTasks.ps1') }
}
