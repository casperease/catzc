# pwsh/Tooling.Core/types/EngineCaseTable.cs

A per-engine fixture table: one row per case, one column per execution engine, so the parity of a behaviour across every engine reads side
by side. `Get-EngineCaseTable` loads one from YAML, and any subject, such as the time safeguard, an engine start or an importer, can keep
its cases in this one shape.

## Shape

```yaml
subject: <what the cases exercise>
cases:
  - case: <unique name>
    pwsh: { <subject-specific fields> } # every engine column is filled ...
    bash: "n/a: <reason>" # ... or names why the case does not apply to that engine
```

## Validation

Constructing an instance validates the table and collects every violation into one `ArgumentException`:

- only the keys `subject` and `cases` at the top, and `case` plus the engine columns in a case;
- a non-empty subject, and unique, non-empty case names;
- every engine column present in every case, as a map or as `n/a: <reason>` with a non-empty reason, so a case can never silently skip an
  engine.

## Columns

The columns are the repository's execution engines, read from their one declaration, `ExecutionEngines.Names`
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)), in that order, so a
table cannot invent one.

## Rows

`Rows` holds one row per case and engine, in file order: the case, the engine, the fields (the column's map, or null) and `not_applicable`
(the reason, or null).
