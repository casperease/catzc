---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Update-AdrCitation.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: update-adr-citation-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: faf089b7b2df
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Update-AdrCitation' -Tag 'L0', 'logic' {`, written with `#`.

```text
Update-AdrCitation rewrites one file's ADR references through a code map and a rule map. Every test writes its own
file into one shared fixture repository in $TestDrive: an ADR index of neutral widget/gizmo codes
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and the two fixture maps under
tests/assets/update-adr-citation/. In them one ADR moves whole to another code and folder, one moves folder and keeps
its code, a folder maps to a new one, one rule moves to a new ADR, and one rule collapses into a kept rule whose path
only the index names.
```
