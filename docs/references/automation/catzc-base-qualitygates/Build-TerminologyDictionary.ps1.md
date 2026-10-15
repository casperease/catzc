# docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md

`automation/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the approved-vocabulary registry (configs/terminology.yml, via Get-Config -Config terminology)
and writes one plain cspell word list per category
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)) to the repository
root's .cspell/<category>.txt
— one file per category defined in the registry (see .cspell/README.md) — the lists cspell.yml references
as separate dictionaries. Each carries a generated-file header comment (cspell treats
'#' lines as comments) naming its source. Each list is lower-cased, de-duplicated, and ordinal-sorted, so the
output is deterministic — the same registry always produces byte-identical bytes. The category set is the
registry's own `categories` map, and every category's file is always emitted, so the generated file set —
and cspell.yml — stay stable.

terminology.yml is the single source of truth; these lists are generated, never hand-edited. Like the
.psd1 manifests they are gitignored and regenerated at the importer tail (see importer.ps1), so cspell
resolves them at fixed paths without a committed second copy of the vocabulary
([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)).

See [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md)
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5),
[ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)) and
[ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8).
```

## comment:2

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report whether any generated list would change without writing the files. The returned content is the
same in either mode; -DryRun simply skips the write. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:3

Section `.PARAMETER Silent` of the comment-based help.

```text
The per-category status lines are verbose-level — shown only when this function is run with -Verbose.
-Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
-Verbose on does not chatter during import).
```

## comment:4

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return one result object per category ({ Category, Path, WordCount, Changed, DryRun }) instead of the
path strings.
```

## comment:5

Above `$categories = @($config.categories)`.

```text
One dictionary per category
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)): each category's
terms generate their own cspell word list, so
cspell.yml can reference — and scope — them independently. The category set is the registry's own
'categories' map (the single source, validated by TerminologyConfig); every category's file is always
emitted (even when it has no terms) so the generated file set stays stable.
```

## comment:6

Above `$cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'`.

```text
The generated dictionaries live at the repository root's .cspell/<category>.txt (see .cspell/README.md).
They are gitignored, so a fresh clone or a deleted .cspell/ has none; [System.IO.File]::WriteAllText does
not create the directory, so self-heal it before writing.
```

## comment:7

Above `$words = [string[]] @(`.

```text
The accepted tokens are the terms themselves (an abbreviation's expansion is a real word cspell
already knows, so it is not registered). Lower-case, de-duplicate, and ordinal-sort per category
for a deterministic list.
```

## comment:8

Above `$header = @(`.

```text
A generated-file header (cspell treats '#' lines as comments) names the single source and how the
file exists — mirrored by .cspell/README.md. It is part of the content, so it is drift-compared too.
```

## comment:9

Above `$dictPath = Join-Path $cspellDir "$category.txt"`.

```text
Gitignored, generated artifact at the repository root's .cspell/
([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)), at the fixed
path
cspell.yml references.
```
