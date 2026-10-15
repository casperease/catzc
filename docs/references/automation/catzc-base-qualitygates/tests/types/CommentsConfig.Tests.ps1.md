---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: ed3cf152a7a4
    adrs:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'CommentsConfig' -Tag 'L0', 'logic' {`.

```text
CommentsConfig maps comments.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key
behaves exactly like the default, and a malformed value fails at construction naming the key.
```
