---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-EngineCaseTable.ps1.md
    kind: reference
    body_sha: "28320ff03398"
    adrs:
      - ADR-AUTO-ENGINE#1
---

# automation/Catzc.Tooling.Core/Get-EngineCaseTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads a YAML engine case table and validates it through the EngineCaseTable type: every case fills every engine
column, or names why it does not apply ("n/a: <reason>"), so the parity of a behaviour across every engine is
explicit case by case. Returns one hashtable per case and engine, shaped for Pester's -ForEach
(Case, Engine, Fields, NotApplicable): Fields is the column's map, NotApplicable the reason when it does not apply.
```

## comment:2

Above `if ($Engine) {`.

```text
The engines are declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)): Get throws, naming them,
for any other name.
```
