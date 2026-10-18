@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Assert-DevBoxToolsStatus', 'Clear-TempFolders', 'Get-ToolsStatus', 'Initialize-GitClone', 'Install-DevBoxTools', 'Install-Git', 'Install-Postman', 'Install-Zsh', 'Uninstall-Chocolatey', 'Uninstall-DevBoxTools', 'Uninstall-Git', 'Uninstall-Postman', 'Uninstall-Zsh')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Find-WindowsGitCredentialManager.ps1', 'private/Get-PackageTreePlan.ps1', 'private/Get-ZshInstallLayout.ps1', 'private/Test-IsWslSession.ps1', 'Assert-DevBoxToolsStatus.ps1', 'Clear-TempFolders.ps1', 'Get-ToolsStatus.ps1', 'Initialize-GitClone.ps1', 'Install-DevBoxTools.ps1', 'Install-Git.ps1', 'Install-Postman.ps1', 'Install-Zsh.ps1', 'Uninstall-Chocolatey.ps1', 'Uninstall-DevBoxTools.ps1', 'Uninstall-Git.ps1', 'Uninstall-Postman.ps1', 'Uninstall-Zsh.ps1') }
}
