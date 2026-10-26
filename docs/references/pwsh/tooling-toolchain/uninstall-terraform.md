# pwsh/Tooling.Toolchain/Uninstall-Terraform.ps1

The uninstaller of Terraform through the platform package manager, the counterpart of `Install-Terraform`.

## help

### synopsis

Uninstalls Terraform via the platform package manager.

### parameter `Version`

Terraform version to uninstall. Defaults to the locked version in Get-ToolConfig.

### example 1

```powershell
Uninstall-Terraform
```
