---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/tests/New-VSCodeLaunch.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "60d526e2a1f8"
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.VSCode/tests/New-VSCodeLaunch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.VSCode {`, written with `#`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): a small
fixture registry.
```
