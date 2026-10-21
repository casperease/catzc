# pwsh/Catzc.Base.QualityGates/Test-Spelling.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Spell-checks the repository's known file types with cspell and writes a report under out/.

### description

Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown, PowerShell, YAML, JSON, C#, and Bicep —
applying the single repo dictionary at /cspell.yml.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every cspell issue
line ('`<path>:<line>:<col>` - Unknown word (`<word>`) …') is an issue, and the gate ends through Write-QualityGateReport, which writes
out/test-spelling/, prints every issue, and throws once listing them all — so the misspelled words are named in the failure itself
([ADR-AUTO-CONSOLE-SELFCONTAINEDERRORS](../../../adr/automation/console-output-matters.md#rule-adr-auto-console-selfcontainederrors)).
-PassThru returns the result object instead. A cspell tool error (exit > 1) or a scan that matched no files throws before the report: there
is no verdict to report.

cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).

### parameter `Path`

Repository-relative paths or globs to check (cspell expands a glob). Defaults to the repository's known file types. cspell still applies the
ignorePaths from cspell.yml.

### parameter `Exclude`

Extra globs a caller wants skipped, passed to cspell as --exclude. Defaults to none: the gate's whole scope, third-party noise and
out-of-scope content alike, is cspell.yml ignorePaths, the one list the terminology corpus reads too.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-spelling`.

### parameter `PassThru`

Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, ExitCode }) instead of throwing.

### example 1

```powershell
Test-Spelling
```

### example 2

```powershell
$result = Test-Spelling -PassThru
$result.IssueCount
```

## comment:1

Above `$checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')`, written with `#`.

```text
cspell prints a summary ("Files checked: N, Issues found: M in K file(s)"). cspell globs are relative to the
working directory (the repo root here), so an empty match means a bad -Path.
```
