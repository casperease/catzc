# automation/pwsh/.scriptanalyzer/NoAzModuleNaming.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoAzModuleNaming {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid Az PowerShell module naming.
.DESCRIPTION
    Azure is spelled out in full so a function name never collides with a cmdlet of the Az modules.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoAzModuleNaming.psm1.md#comment1)
```

## comment:2

Above `$isFunctionDefinition = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/adr/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```
