# pwsh/.scriptanalyzer/NeverDependOnPwd.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NeverDependOnPwd {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: never depend on $PWD.
.DESCRIPTION
    Push-Location and Pop-Location pass: they restore the caller's directory, a bare Set-Location does not.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NeverDependOnPwd.psm1.md#comment1)
```

## comment:2

Above `$isVariable = {`, written with `#`.

```text
Flag $PWD references
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `$isCommand = {`, written with `#`.

```text
Flag Set-Location / cd calls (Push-Location / Pop-Location are fine)
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
