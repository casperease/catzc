---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md
    kind: comment-page
    body_sha: "8809143ab6bf"
    adrs:
      - ADR-AUTO-CONSOLE#6
      - ADR-AUTO-TEST#35
      - ADR-REPO-README#7
---

# automation/Catzc.Base.QualityGates/Test-Spelling.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the Code Spell Checker CLI (cspell) over the repository's known text file types — Markdown,
PowerShell, YAML, JSON, C#, and Bicep — applying the single repo dictionary at /cspell.yml.

A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every
cspell issue line ('<path>:<line>:<col> - Unknown word (<word>) …') is an issue, and the gate ends through
Write-QualityGateReport, which writes out/test-spelling/, prints every issue, and throws once listing them all
— so the misspelled words are named in the failure itself
([ADR-AUTO-CONSOLE#6](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console6)).
-PassThru returns the result object instead. A cspell tool error (exit > 1) or a scan that matched no files
throws before the report: there is no verdict to report.

cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
Repository-relative paths or globs to check (cspell expands a glob). Defaults to the repository's known file types.
cspell still applies the ignorePaths from cspell.yml.
```

## comment:3

Section `.PARAMETER Exclude` of the comment-based help.

```text
Globs the spelling QUALITY GATE skips, passed to cspell as --exclude. Defaults to the authored/generated trees
that are out of scope to spell-check (out/, docs/notes, the machine-derived configuration/**
trees). Non-authored noise (vendor, install scripts, compiled output, binaries) lives in cspell.yml
ignorePaths instead — this parameter is for content scope, not third-party noise.
```

## comment:4

Above `[string[]] $Exclude = @(`.

```text
Content the spelling quality gate does NOT check (authored/generated text, not third-party noise — that
lives in cspell.yml ignorePaths). Passed to cspell as --exclude globs.
```

## comment:5

Above `'**/README.md'`.

```text
Generated README copy-ins (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
and their authored source under docs/ is what is spell-checked (mirrors Test-Markdownlint's
'!**/README.md'). Their banner embeds the source's kebab filename, which is not a word. See
[ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7).
```

## comment:6

Above `'docs/adr/index.md'`.

```text
[index](/docs/adr/index.md) is generated from adrs.yml (Build-AdrIndex) — a derived artifact; its source
(adrs.yml + the generator's prose) is what is reviewed, not the projection.
```

## comment:7

Above `'docs/adr/glossary.md'`.

```text
[glossary](/docs/adr/glossary.md) is generated from the configs/glossary.yml sources (Build-Glossary) — likewise
derived; the sources are what is spell-checked.
```

## comment:8

Above `$excludeArgs = foreach ($e in $Exclude) {`.

```text
Content-scope exclusions (out/, docs/notes, generated config trees) — cspell ignorePaths rejects
negation globs, so the gate's content scope is expressed here as --exclude on the command line.
```

## comment:9

Above `$checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')`.

```text
cspell prints a summary ("Files checked: N, Issues found: M in K file(s)"). cspell globs are relative to the
working directory (the repo root here), so an empty match means a bad -Path.
```

## comment:10

Above `'**/README.md'`.

```text
Generated README copy-ins (Catzc.Base.Docs) are derived artifacts, not source: they are gitignored
and their authored source under docs/ is what is spell-checked (mirrors Test-Markdownlint's
'!**/README.md'). Their banner embeds the source's kebab filename, which is not a word. See
[ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7).
```

## comment:11

Above `'docs/adr/index.md'`.

```text
[index](/docs/adr/index.md) is generated from adrs.yml (Build-AdrIndex) — a derived artifact; its source
(adrs.yml + the generator's prose) is what is reviewed, not the projection.
```

## comment:12

Above `'docs/adr/glossary.md'`.

```text
[glossary](/docs/adr/glossary.md) is generated from the configs/glossary.yml sources (Build-Glossary) — likewise
derived; the sources are what is spell-checked.
```

## comment:13

Above `$excludeArgs = foreach ($e in $Exclude) {`.

```text
Content-scope exclusions (out/, docs/notes, generated config trees) — cspell ignorePaths rejects
negation globs, so the gate's content scope is expressed here as --exclude on the command line.
```

## comment:14

Above `$checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')`.

```text
cspell prints a summary ("Files checked: N, Issues found: M in K file(s)"). cspell globs are relative to the
working directory (the repo root here), so an empty match means a bad -Path.
```
