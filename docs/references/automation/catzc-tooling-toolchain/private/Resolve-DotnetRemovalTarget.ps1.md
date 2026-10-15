---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Resolve-DotnetRemovalTarget.ps1.md
    kind: comment-page
    body_sha: "1adfd7e45330"
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Tooling.Toolchain/private/Resolve-DotnetRemovalTarget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The folder of the `dotnet` on PATH, unless that is the managed user-space install (Test-ExpectedPackageManager
-Path) — in a catzc session it always is, because the importer puts the managed install first — in which case the
machine-wide C:\Program Files\dotnet, the folder a system installer places. Remove-Dotnet's -InstallDir default
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```
