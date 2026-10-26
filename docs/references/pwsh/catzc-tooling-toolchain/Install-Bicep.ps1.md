# pwsh/Tooling.Toolchain/Install-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs the Bicep CLI, the formatter engine for the infrastructure templates, at the tools.yml pin.

### description

The Bicep CLI is the `bicep` engine Format-Code runs over every .bicep file (languages.yml;
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)). Windows
and macOS delegate to Install-Tool: winget Microsoft.Bicep as a user-scope portable (no admin), or brew from Microsoft's tap
([ADR-AUTO-PKGMGR](../../../drs/automation/use-proper-package-managers.md)). Linux has no distribution package, so it installs the release
binary, verified against its published SHA-256, into ~/.local/bin (Install-BicepStandalone). Idempotent: a Bicep CLI already at the pinned
version is left alone; another version throws unless -Force.

### parameter `Version`

The version prefix to install. Default: the tools.yml pin.

### parameter `Force`

Replace an installed Bicep CLI at another version.

### example 1

```powershell
Install-Bicep
```
