# pwsh/.scriptanalyzer/FunctionLength.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-FunctionLength {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: function body must not exceed 300 lines.
.DESCRIPTION
    Help placed before the function is outside the braces, so it never counts toward the limit.
    [comment:1](/docs/references/pwsh/scriptanalyzer/FunctionLength.psm1.md#comment1)
```

## comment:2

Above `$isFunctionDefinition = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```

## comment:3

Above `$modulesRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))`, written with `#`.

```text
The rule sits in the modules root, so it reads file-limits.yml from there; an analyzer shard process has no
Get-Config.
```

## comment:4

Above `. (Join-Path $modulesRoot '.internal/assets/bootstrap/Resolve-ModuleName.ps1')`, written with `#`.

```text
Module folders resolve from their full names under the track's namespace, read before any import
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
```
