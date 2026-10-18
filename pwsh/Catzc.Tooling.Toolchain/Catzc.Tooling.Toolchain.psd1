@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Install-AzCli', 'Install-Bicep', 'Install-Dotnet', 'Install-Go', 'Install-Java', 'Install-Shellcheck', 'Install-Terraform', 'Install-Uv', 'Invoke-Dotnet', 'Invoke-Go', 'Invoke-Java', 'Invoke-Terraform', 'Remove-AzCli', 'Remove-Dotnet', 'Remove-Java', 'Uninstall-AzCli', 'Uninstall-Bicep', 'Uninstall-Dotnet', 'Uninstall-Go', 'Uninstall-Java', 'Uninstall-Shellcheck', 'Uninstall-Terraform', 'Uninstall-Uv', 'Update-BatsVendor')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-DotnetInstallHolder.ps1', 'private/Get-GoRelease.ps1', 'private/Get-RegisteredInstallProduct.ps1', 'private/Install-BicepStandalone.ps1', 'private/Install-UvStandalone.ps1', 'private/Resolve-DotnetRemovalTarget.ps1', 'private/Stop-DotnetInstallHolder.ps1', 'Install-AzCli.ps1', 'Install-Bicep.ps1', 'Install-Dotnet.ps1', 'Install-Go.ps1', 'Install-Java.ps1', 'Install-Shellcheck.ps1', 'Install-Terraform.ps1', 'Install-Uv.ps1', 'Invoke-Dotnet.ps1', 'Invoke-Go.ps1', 'Invoke-Java.ps1', 'Invoke-Terraform.ps1', 'Remove-AzCli.ps1', 'Remove-Dotnet.ps1', 'Remove-Java.ps1', 'Uninstall-AzCli.ps1', 'Uninstall-Bicep.ps1', 'Uninstall-Dotnet.ps1', 'Uninstall-Go.ps1', 'Uninstall-Java.ps1', 'Uninstall-Shellcheck.ps1', 'Uninstall-Terraform.ps1', 'Uninstall-Uv.ps1', 'Update-BatsVendor.ps1') }
}
