# docs/references/automation/catzc-base-qualitygates/Measure-QualityGates.ps1.md

`automation/Catzc.Base.QualityGates/Measure-QualityGates.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Read-only measurement, not a gate: it runs each named quality gate once with -PassThru (its report going to a
throwaway folder) and returns one row per gate — its wall-clock seconds, its issue count, and the error when it
threw — slowest first. By default it times every gate languages.yml names in a language's `checks` (the gates
Test-Change runs), so the zero-argument call answers "which of my per-change checks is slow".

With -AnalyzerRules it times the analyzer instead: each PSScriptAnalyzer rule the settings enable, run alone (-IncludeRule)
over every -Every'th file of the analyzed files (Get-AutomationSourceFiles). The repository's custom checks run
through one entry rule (Measure-CatzcRules) and are timed as that one row.
```

## comment:2

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
