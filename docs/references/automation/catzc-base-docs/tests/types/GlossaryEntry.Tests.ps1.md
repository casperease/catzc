---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md
    kind: test-asset
    body_sha: e8b1f25e9678
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GlossaryEntry' -Tag 'L0', 'logic' {`.

```text
Validates the compiled GlossaryEntry result type — one merged concept with its owning module, source path, and
options. Fixture terms are neutral (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
