---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "546fcb02ab1f"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GlossaryConfig' -Tag 'L0', 'logic' {`.

```text
Validates the compiled GlossaryConfig type and the records it builds (GlossaryOptions, GlossaryConcept,
GlossaryRealization, GlossaryAvoid) directly — the constructor is the guard that stops a malformed glossary source
from ever producing an instance. Only the self-contained load-time rules live here; the cross-source and
cross-file checks belong to the glossary checks. Fixture terms are neutral (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
