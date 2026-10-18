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
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```
