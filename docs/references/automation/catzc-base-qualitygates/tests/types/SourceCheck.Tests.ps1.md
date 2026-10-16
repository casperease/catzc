---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d8e22f2b444a
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'SourceCheck' -Tag 'L0', 'logic' {`, written with `#`.

```text
SourceCheck maps the settings every source check shares — its mode and exempt globs — and is the one declaration of
their sensible defaults ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)); an
exempt file is a declared entry with its reason
([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)).
```
