# automation/Catzc.Tooling.Toolchain/private/Install-BicepStandalone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs the Bicep CLI on Linux: the newest release at the pinned version, verified, into ~/.local/bin.

### description

Linux has no distribution package for the Bicep CLI, so Install-Bicep comes here. The newest Azure/bicep release whose tag matches the pin
is resolved from the GitHub releases API, and its single-file binary for this machine's architecture (bicep-linux-x64 or bicep-linux-arm64)
is downloaded through Save-VerifiedDownload against the SHA-256 GitHub publishes for the asset (`digest`) — an asset without one is refused,
never run unverified ([ADR-AUTO-PKGMGR](../../../../adr/automation/use-proper-package-managers.md)). It lands in the user's ~/.local/bin
(the same user-space bin as the standalone uv), marked executable; no root is needed.

### parameter `Version`

The version prefix to install (e.g. 0.48).

### example 1

```powershell
Install-BicepStandalone -Version 0.48
```
