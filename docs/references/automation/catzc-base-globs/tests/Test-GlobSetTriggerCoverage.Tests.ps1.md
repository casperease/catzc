---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fdf3860d3577
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GlobSetTriggerCoverage' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-GlobSetTriggerCoverage over mocked globsets, projections, and members; the include patterns are real
GlobPattern instances. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
