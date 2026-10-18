# automation/Catzc.Tooling.Toolchain/Install-Terraform.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs Terraform via the platform package manager.

### description

Windows: winget. macOS: Homebrew (hashicorp/tap). Linux: HashiCorp apt repository (configured inline if not already present). Idempotent —
skips if already installed at the correct version.

### parameter `Version`

Terraform version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Terraform
```

### example 2

```powershell
Install-Terraform -Version '1.15'
```
