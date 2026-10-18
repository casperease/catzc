# pwsh/.scriptanalyzer/NoRawInformationStream.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoRawInformationStream {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid calling Write-Information directly.
.DESCRIPTION
    A direct Write-Information skips the Pester guard, so its output leaks into test output and loses the caller header.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoRawInformationStream.psm1.md#comment1)
```

## comment:2

Above `$isCommand = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```
