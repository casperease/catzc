# pwsh/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Generates the per-category spell-checker dictionaries from the terminology registry — the writer half of Test-Terminology.

### description

Reads the approved-vocabulary registry (configs/terminology.yml, via Get-Config -Config terminology) and writes one plain cspell word list
per category ([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)) to the
repository root's `.cspell/<category>.txt` — one file per category defined in the registry (see .cspell/README.md) — the lists cspell.yml
references as separate dictionaries. Each carries the generated-file head as a comment (cspell treats '#' lines as comments) naming its
generator and source. Each list is lower-cased, de-duplicated, and ordinal-sorted, so the output is deterministic — the same registry always
produces byte-identical bytes. The category set is the registry's own `categories` map, and every category's file is always emitted, so the
generated file set — and cspell.yml — stay stable.

terminology.yml is the single source of truth; these lists are generated, never hand-edited. Like the .psd1 manifests they are gitignored
and regenerated at the importer tail (see importer.ps1), so cspell resolves them at fixed paths without a committed second copy of the
vocabulary
([ADR-REPO-OUTDIR-DICTIONARIESGENERATED](../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated)).

See [ADR-AUTO-SPELL](../../../drs/automation/spell-out-names.md)
([ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource),
[ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)) and
[ADR-REPO-OUTDIR-DICTIONARIESGENERATED](../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated).

### parameter `DryRun`

Report whether any generated list would change without writing the files. The returned content is the same in either mode; -DryRun simply
skips the write. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Silent`

The per-category status lines are verbose-level — shown only when this function is run with -Verbose. -Silent suppresses them entirely, even
under -Verbose (used by the importer tail so a session with -Verbose on does not chatter during import).

### parameter `PassThru`

Return one result object per category ({ Category, Path, WordCount, Changed, DryRun }) instead of the path strings.

### outputs

`[string[]]` The paths to the generated dictionaries (with -PassThru, one result object per category instead).

### example 1

```powershell
Build-TerminologyDictionary
Regenerates the per-category dictionaries from the registry.
```

### example 2

```powershell
Build-TerminologyDictionary -DryRun -PassThru
Reports whether any checked-in list is stale without writing it.
```

## comment:1

Above `$categories = @($config.categories)`, written with `#`.

```text
One dictionary per category
([ADR-AUTO-SPELL-CATEGORYANDMEANING](/docs/drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)): each category's
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
A generated-file head (cspell treats '#' lines as comments) carries the do-not-edit warning —
mirrored by .cspell/README.md. It is part of the content, so it is drift-compared too.
```

## comment:5

Above `$dictPath = Join-Path $cspellDir "$category.txt"`, written with `#`.

```text
Gitignored, generated artifact at the repository root's .cspell/
([ADR-REPO-OUTDIR-DICTIONARIESGENERATED](/docs/drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated)), at the fixed
path
cspell.yml references.
```
