---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/New-GitIgnore.Tests.ps1.md
    kind: test-asset
    body_sha: "30b22f9b443d"
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.Git/tests/New-GitIgnore.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.Git {`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): a small
fixture registry with one static section (a
noted and a bare pattern) and one injected section.
```
