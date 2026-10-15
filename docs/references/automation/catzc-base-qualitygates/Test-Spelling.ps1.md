---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md
    kind: comment-page
    body_sha: "37baeb380730"
    adrs:
      - ADR-REPO-README#7
---

# automation/Catzc.Base.QualityGates/Test-Spelling.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
