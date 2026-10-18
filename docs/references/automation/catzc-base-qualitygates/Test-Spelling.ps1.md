# automation/Catzc.Base.QualityGates/Test-Spelling.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Spell-checks the repository's known file types with cspell and writes a report under out/.

### description

Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown, PowerShell, YAML, JSON, C#, and Bicep —
applying the single repo dictionary at /cspell.yml.

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)): every cspell issue line
('`<path>:<line>:<col>` - Unknown word (`<word>`) …') is an issue, and the gate ends through Write-QualityGateReport, which writes
out/test-spelling/, prints every issue, and throws once listing them all — so the misspelled words are named in the failure itself
([ADR-AUTO-CONSOLE#6](../../../adr/automation/console-output-matters.md#rule-adr-auto-console6)). -PassThru returns the result object
instead. A cspell tool error (exit > 1) or a scan that matched no files throws before the report: there is no verdict to report.

cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).

### parameter Path

Repository-relative paths or globs to check (cspell expands a glob). Defaults to the repository's known file types. cspell still applies the
ignorePaths from cspell.yml.

### parameter Exclude

Globs the spelling QUALITY GATE skips, passed to cspell as --exclude. Defaults to the authored/generated trees that are out of scope to
spell-check (out/, docs/notes, the machine-derived `configuration/**` trees). Non-authored noise (vendor, install scripts, compiled output,
binaries) lives in cspell.yml ignorePaths instead — this parameter is for content scope, not third-party noise. Content the spelling quality
gate does NOT check (authored/generated text, not third-party noise — that lives in cspell.yml ignorePaths). Passed to cspell as --exclude
globs.

### parameter OutputFolder

The report base folder. Defaults to `<out>/test-spelling`.

### parameter PassThru

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

Above `'**/README.md'`, written with `#`.

```text
Generated README copy-ins (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
and their authored source under docs/ is what is spell-checked (mirrors Test-Markdownlint's
'!**/README.md'). Their banner embeds the source's kebab filename, which is not a word. See
[ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7).
```

## comment:2

Above `'docs/adr/index.md'`, written with `#`.

```text
[index](/docs/adr/index.md) is generated from adrs.yml (Build-AdrIndex) — a derived artifact; its source
(adrs.yml + the generator's prose) is what is reviewed, not the projection.
```

## comment:3

Above `'docs/adr/glossary.md'`, written with `#`.

```text
[glossary](/docs/adr/glossary.md) is generated from the configs/glossary.yml sources (Build-Glossary) — likewise
derived; the sources are what is spell-checked.
```

## comment:4

Above `$excludeArgs = foreach ($e in $Exclude) {`, written with `#`.

```text
Content-scope exclusions (out/, docs/notes, generated config trees) — cspell ignorePaths rejects
negation globs, so the gate's content scope is expressed here as --exclude on the command line.
```

## comment:5

Above `$checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')`, written with `#`.

```text
cspell prints a summary ("Files checked: N, Issues found: M in K file(s)"). cspell globs are relative to the
working directory (the repo root here), so an empty match means a bad -Path.
```
