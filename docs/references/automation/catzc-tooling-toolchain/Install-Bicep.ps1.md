---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Bicep.ps1.md
    kind: comment-page
    body_sha: b505186b6825
    adrs:
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Tooling.Toolchain/Install-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The Bicep CLI is the `bicep` engine Format-Code runs over every .bicep file (languages.yml;
[ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)). Windows and macOS delegate to
Install-Tool: winget Microsoft.Bicep as a user-scope portable (no admin), or brew from Microsoft's tap
([ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md)). Linux has no distribution package, so it
installs the release binary, verified against its published SHA-256, into ~/.local/bin (Install-BicepStandalone).
Idempotent: a Bicep CLI already at the pinned version is left alone; another version throws unless -Force.
```
