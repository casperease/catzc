# docs/references/automation/catzc-tooling-toolchain/private/Install-BicepStandalone.ps1.md

`automation/Catzc.Tooling.Toolchain/private/Install-BicepStandalone.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Linux has no distribution package for the Bicep CLI, so Install-Bicep comes here. The newest Azure/bicep release
whose tag matches the pin is resolved from the GitHub releases API, and its single-file binary for this machine's
architecture (bicep-linux-x64 or bicep-linux-arm64) is downloaded through Save-VerifiedDownload against the SHA-256
GitHub publishes for the asset (`digest`) — an asset without one is refused, never run unverified
([ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md)). It lands in the user's ~/.local/bin (the
same user-space bin as the standalone uv), marked executable; no root is needed.
```
