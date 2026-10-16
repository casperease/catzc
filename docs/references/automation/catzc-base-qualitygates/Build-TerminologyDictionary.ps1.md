---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e2f11e10d89e
    adrs:
      - ADR-AUTO-SPELL#6
      - ADR-REPO-OUTDIR#8
---

# automation/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$categories = @($config.categories)`, written with `#`.

```text
One dictionary per category
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)): each category's
terms generate their own cspell word list, so
cspell.yml can reference — and scope — them independently. The category set is the registry's own
'categories' map (the single source, validated by TerminologyConfig); every category's file is always
emitted (even when it has no terms) so the generated file set stays stable.
```

## comment:2

Above `$cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'`, written with `#`.

```text
The generated dictionaries live at the repository root's .cspell/<category>.txt (see .cspell/README.md).
They are gitignored, so a fresh clone or a deleted .cspell/ has none; [System.IO.File]::WriteAllText does
not create the directory, so self-heal it before writing.
```

## comment:3

Above `$words = [string[]] @(`, written with `#`.

```text
The accepted tokens are the terms themselves (an abbreviation's expansion is a real word cspell
already knows, so it is not registered). Lower-case, de-duplicate, and ordinal-sort per category
for a deterministic list.
```

## comment:4

Above `$text = if ($words.Count -gt 0) {`, written with `#`.

```text
A generated-file head (cspell treats '#' lines as comments) names the generator and the single source —
mirrored by .cspell/README.md. It is part of the content, so it is drift-compared too.
```

## comment:5

Above `$dictPath = Join-Path $cspellDir "$category.txt"`, written with `#`.

```text
Gitignored, generated artifact at the repository root's .cspell/
([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)), at the fixed
path
cspell.yml references.
```
