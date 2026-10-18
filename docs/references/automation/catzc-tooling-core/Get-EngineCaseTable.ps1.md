# automation/Catzc.Tooling.Core/Get-EngineCaseTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
Get-EngineCaseTable automation/Catzc.Base.Timeouts/tests/assets/engine-cases/bounded-command.yml -Applicable
```

## comment:1

Above `if ($Engine) {`, written with `#`.

```text
The engines are declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)): Get throws, naming them,
for any other name.
```
