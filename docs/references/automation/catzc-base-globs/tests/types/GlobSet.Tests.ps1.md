---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
    kind: test-asset
    body_sha: e50ce473267f
    adrs:
      - ADR-FLOW-CD-GLOBS#4
      - ADR-FLOW-CD-GLOBS#8
---

# automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GlobSet' -Tag 'L0', 'logic' {`.

```text
The globset record: membership is decided by the scan program — an ordered +/- rule list, last-match-wins
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)), flattened through compose with
own-rules-last
([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)); and the constructor guards the
shape (kebab-case name, required description, a layer declared, include or compose present, no duplicate
patterns).
```
