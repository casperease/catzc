---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-EngineCaseTable.ps1.md
    folder: docs/references/automation/catzc-tooling-core
    name: get-engine-case-table-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "84b1227cebe0"
    adrs:
      - ADR-AUTO-ENGINE#1
---

# automation/Catzc.Tooling.Core/Get-EngineCaseTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Engine) {`, written with `#`.

```text
The engines are declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)): Get throws, naming them,
for any other name.
```
