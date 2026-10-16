---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Spelling.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f5d9fdeefc2b
    adrs:
      - ADR-REPO-README#7
---

# automation/Catzc.Base.QualityGates/Test-Spelling.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
