# automation/Catzc.Tooling.Toolchain/Uninstall-Terraform.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls Terraform via the platform package manager.

### parameter Version

Terraform version to uninstall. Defaults to the locked version in Get-ToolConfig.

### example 1

```powershell
Uninstall-Terraform
```
