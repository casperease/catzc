---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/types/EngineCaseTable.cs.md
    kind: comment-page
    body_sha: "39d18eb1956a"
    adrs:
      - ADR-AUTO-ENGINE#1
    links: []
---

# automation/Catzc.Tooling.Core/types/EngineCaseTable.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A per-engine fixture table: one row per case, one column per execution engine (ExecutionEngines), so the
parity of a behaviour across every engine reads side by side. Get-EngineCaseTable loads one from YAML; any
subject (the time safeguard, an engine start, an importer) can keep its cases in this one shape.

  subject: <what the cases exercise>
  cases:
    - case: <unique name>
      pwsh: { <subject-specific fields> }     # every engine column is filled ...
      bash: "n/a: <reason>"                   # ... or names why the case does not apply to that engine

Constructing an instance validates the table, collecting every violation into one ArgumentException:
  - only the keys subject and cases at the top, and case plus the engine columns in a case;
  - a non-empty subject; unique, non-empty case names;
  - every engine column present in every case, as a map or as "n/a: <reason>" with a non-empty reason — so a case
    can never silently skip an engine.
The columns are the repository's execution engines, read from their one declaration (ExecutionEngines.Names,
[ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)), so a table cannot invent one.
```

## comment:2

Above `private static readonly IReadOnlyList<string> Engines =...`.

```text
The columns: the execution engines, declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)), in their order.
```

## comment:3

Above `public IReadOnlyList<Hashtable> Rows { get { return rows; } }`.

```text
One row per case and engine, in file order: case, engine, fields (the column's map, or null) and not_applicable
(the reason, or null).
```
