# pwsh/Catzc.Base.QualityGates/Measure-QualityGates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Times quality gates (or analyzer rules), to find what makes a check slow.

### description

Read-only measurement, not a gate: it runs each named quality gate once with -PassThru (its report going to a throwaway folder) and returns
one row per gate — its wall-clock seconds, its issue count, and the error when it threw — slowest first. By default it times every gate
languages.yml names in a language's `checks` (the gates Test-Change runs), so the zero-argument call answers "which of my per-change checks
is slow".

With -AnalyzerRules it times the analyzer instead: each PSScriptAnalyzer rule the settings enable, run alone (-IncludeRule) over every
-Every'th file of the analyzed files (Get-ModuleSourceFile). The repository's custom checks run through one entry rule (Measure-CatzcRules)
and are timed as that one row.

### parameter `Name`

The quality gates to time. Default: every gate a language's `checks` names in languages.yml.

### parameter `AnalyzerRules`

Time each analyzer rule instead of the gates.

### parameter `Every`

With -AnalyzerRules: analyze every Nth file (1 = all of them). Default 8, a sample that keeps the run short.

### outputs

`[pscustomobject]` { Name; Seconds; IssueCount; Error }, slowest first.

### example 1

```powershell
Measure-QualityGates
```

### example 2

```powershell
Measure-QualityGates Test-Spelling, Test-Links
```

### example 3

```powershell
Measure-QualityGates -AnalyzerRules -Every 4 | Select-Object -First 10
```

## comment:1

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`, written with `#`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).
```
