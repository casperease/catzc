---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-CatsAdrRuleIds.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9110c2f64094"
---

# automation/Catzc.Base.Docs/tests/Get-CatsAdrRuleIds.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:adrRoot = Join-Path $TestDrive 'adr'`, written with `#`.

```text
A fixture ADR tree: an index beside two ADR files it lists (paths relative to the index folder),
plus a third ADR the index does NOT list — so we can assert only listed ADRs contribute.
```
