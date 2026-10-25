# pwsh/.scriptanalyzer/NoScriptRootAnchor.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoScriptRootAnchor {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid $PSScriptRoot anchors in module function files.
.DESCRIPTION
    In build mode the functions merge into one file, so the script root no longer names the module folder.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoScriptRootAnchor.psm1.md#comment1)
```

## comment:2

Above `$file = $ScriptBlockAst.Extent.File`, written with `#`.

```text
Only module function files are in scope: pwsh/<Module>/<File>.ps1 or pwsh/<Module>/private/<File>.ps1,
where <Module> is not dot-prefixed (.internal, .scriptanalyzer, .vendor are infrastructure).
```

## comment:3

Above `$isVariable = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```
