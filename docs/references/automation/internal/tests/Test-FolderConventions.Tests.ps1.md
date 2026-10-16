---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Test-FolderConventions.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f201ce362b2e
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/.internal/tests/Test-FolderConventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Folder & file conventions' -Tag 'L0', 'integrity' {`, written with `#`.

```text
The folder and file conventions over the real tree, through their quality gate (Test-FolderConventions,
Catzc.Base.ModuleSystem — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The gate
scans the tree once and lists every offender; this block runs it at its tier and guards it against a silent no-op.
```
