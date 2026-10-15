---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
    kind: test-asset
    body_sha: "775d66ed25ae"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'SourceCheck' -Tag 'L0', 'logic' {`.

```text
SourceCheck maps the settings every source check shares — its mode and exempt globs — and is the one declaration of
their sensible defaults ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)); an
exempt file is a declared entry with its reason
([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)).
```
