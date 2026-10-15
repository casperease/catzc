---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-CatsAdrRuleIds.Tests.ps1.md
    kind: test-asset
    body_sha: "19470c09e320"
---

# automation/Catzc.Base.Docs/tests/Get-CatsAdrRuleIds.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:adrRoot = Join-Path $TestDrive 'adr'`.

```text
A fixture ADR tree: an index beside two ADR files it lists (paths relative to the index folder),
plus a third ADR the index does NOT list — so we can assert only listed ADRs contribute.
```
