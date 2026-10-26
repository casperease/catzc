# pwsh/Tooling.Core/Get-EngineCaseTable.ps1

The loader of a per-engine fixture table: it reads a YAML table of cases and returns one row per case and execution engine, validated
through the `EngineCaseTable` type and shaped for Pester's `-ForEach`.

## help

### synopsis

Loads a per-engine fixture table: one row per case and execution engine (ExecutionEngines), validated.

### description

Reads a YAML engine case table and validates it through the EngineCaseTable type: every case fills every engine column, or names why it does
not apply ("n/a: `<reason>`"), so the parity of a behaviour across every engine is explicit case by case. Returns one hashtable per case and
engine, shaped for Pester's -ForEach (Case, Engine, Fields, NotApplicable): Fields is the column's map, NotApplicable the reason when it
does not apply.

### parameter `Path`

The table file: absolute, or relative to the repository root (never to the current directory).

### parameter `Engine`

Return only this engine's rows.

### parameter `Applicable`

Return only the rows that apply (skip the "n/a" cells).

### outputs

`[hashtable]` One per case and engine, in file order.

### example 1

```powershell
Get-EngineCaseTable pwsh/Base.Timeouts/tests/assets/engine-cases/bounded-command.yml -Applicable
```

## Engines

The engines are declared once
([ADR-AUTO-ENGINE-THREEENGINES](../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)); `-Engine` with any other
name throws, naming the declared ones.
