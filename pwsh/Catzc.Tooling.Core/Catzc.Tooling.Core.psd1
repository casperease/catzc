@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-Tool', 'Get-EngineCaseTable', 'Get-InstallScope', 'Get-ScriptInstallDir', 'Get-ToolCommandSuffix', 'Get-ToolConfig', 'Get-ToolInstallOrder', 'Get-ToolVersion', 'Install-Tool', 'Install-UvTool', 'Install-UvVenvTool', 'Invoke-Uv', 'Remove-LinuxToolInstall', 'Remove-MacToolInstall', 'Remove-SystemInstallation', 'Save-VerifiedDownload', 'Sync-SessionTools', 'Test-ExpectedPackageManager', 'Test-Tool', 'Test-ToolRequiresElevation', 'Uninstall-Tool', 'Uninstall-UvTool', 'Uninstall-UvVenvTool', 'Write-ToolProbeReport')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Assert-ToolVersion.ps1', 'private/Get-UvVenvDir.ps1', 'private/Remove-UvPipOrStrayInstall.ps1', 'private/Resolve-SessionToolHint.ps1', 'private/Resolve-SessionToolHost.ps1', 'private/Test-ToolHomeProbe.ps1', 'private/Test-ToolLocationManaged.ps1', 'Assert-Tool.ps1', 'Get-EngineCaseTable.ps1', 'Get-InstallScope.ps1', 'Get-ScriptInstallDir.ps1', 'Get-ToolCommandSuffix.ps1', 'Get-ToolConfig.ps1', 'Get-ToolInstallOrder.ps1', 'Get-ToolVersion.ps1', 'Install-Tool.ps1', 'Install-UvTool.ps1', 'Install-UvVenvTool.ps1', 'Invoke-Uv.ps1', 'Remove-LinuxToolInstall.ps1', 'Remove-MacToolInstall.ps1', 'Remove-SystemInstallation.ps1', 'Save-VerifiedDownload.ps1', 'Sync-SessionTools.ps1', 'Test-ExpectedPackageManager.ps1', 'Test-Tool.ps1', 'Test-ToolRequiresElevation.ps1', 'Uninstall-Tool.ps1', 'Uninstall-UvTool.ps1', 'Uninstall-UvVenvTool.ps1', 'Write-ToolProbeReport.ps1') }
}
