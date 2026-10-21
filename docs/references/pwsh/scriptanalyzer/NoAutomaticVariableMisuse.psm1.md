# pwsh/.scriptanalyzer/NoAutomaticVariableMisuse.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoAutomaticVariableMisuse {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid use of $?.
.DESCRIPTION
    $? is overwritten by every statement, making it impossible to check reliably.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoAutomaticVariableMisuse.psm1.md#comment1)
```

## comment:2

Above `$isQuestionMarkVariable = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```
