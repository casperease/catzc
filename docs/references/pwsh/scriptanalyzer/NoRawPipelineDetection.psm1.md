# automation/pwsh/.scriptanalyzer/NoRawPipelineDetection.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoRawPipelineDetection {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid raw pipeline-detection env reads.
.DESCRIPTION
    One detector owns the agent variables, so the checked set stays hidden and both platforms are always covered.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoRawPipelineDetection.psm1.md#comment1)
```

## comment:2

Above `$isVariable = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/adr/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```
