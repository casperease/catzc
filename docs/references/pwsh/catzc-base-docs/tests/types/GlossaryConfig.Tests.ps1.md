# pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlossaryConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
Validates the compiled GlossaryConfig type and the records it builds (GlossaryOptions, GlossaryConcept,
GlossaryRealization, GlossaryAvoid) directly — the constructor is the guard that stops a malformed glossary source
from ever producing an instance. Only the self-contained load-time rules live here; the cross-source and
cross-file checks belong to the glossary checks. Fixture terms are neutral (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
