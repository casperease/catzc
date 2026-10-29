# pwsh/Base.QualityGates/Test-Spelling.ps1

The quality gate for spelling: it runs cspell over the repository's known file types and writes a report to the output folder.

## help

### synopsis

Spell-checks the repository's known file types with cspell and writes a report to the output folder.

### description

Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown, PowerShell, YAML, JSON, C#, and Bicep —
applying the single repo dictionary at /cspell.yml.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every cspell issue
line ('`<path>:<line>:<col>` - Unknown word (`<word>`) …') is an issue, and the gate ends through Write-QualityGateReport, which writes
out/test-spelling/, prints every issue, and throws once listing them all — so the misspelled words are named in the failure itself
([ADR-AUTO-CONSOLE-SELFCONTAINEDERRORS](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-selfcontainederrors)).
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

## Flags

`--dot` spells the tracked files under a dot folder (`.assets`, `.claude`), and `--gitignore` keeps the untracked ones under it out.

`--cache --cache-strategy content` keeps a cache per path group under `out/spelling-cache/`, one file named by the group's hash, so parallel
groups never share one. An entry holds when the file's content, the config and dictionaries it read, and the cspell version are all
unchanged; any change spells that file again, so the cache never hides a finding. A warm whole-repository scan takes about 5 s, against
about 18 s without it (2026-10-29).

## Counting files

cspell prints a summary ("Files checked: N, Issues found: M in K file(s)"). Its globs are relative to the working directory, the repository
root here, so an empty match means a bad `-Path`. A run whose files checked cannot be counted proves nothing either, because the wording
changed or cspell stopped before its summary, so the gate reports that as an issue.

## comment:1

Above `$command = (`, written with `#`.

```text
--dot reaches tracked files under dot folders; --gitignore keeps the untracked ones out.
--cache-strategy content keys an entry by the file's content, never its timestamp.
```
