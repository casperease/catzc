---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FormatScope.ps1.md
    kind: comment-page
    body_sha: af2bef3d72fa
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-CONFIG#4
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.QualityGates/private/Get-FormatScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One scope for every formatter engine ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)):
without -Path, every file git tracks (Get-GitTrackedPath); with -Path, each given file as it is (tracked or not,
inside the repository or not — a build output manifest is formatted the same way), and each given folder's
tracked files. Fixture files are formatted like any other file. Third-party code that .gitattributes marks
`linguist-vendored` is never formatted: it stays as its publisher shipped it. Nor is a contract asset, which
.gitattributes marks `catzc-contract`: its bytes are what a contract check compares
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)), and a released contract
version stays byte-frozen ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)), so
a formatter upgrade must never rewrite one. Both classes are declared once, in the .gitattributes source
([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)). A tracked file deleted
from the working tree is left out.
```
