# pwsh/Base.QualityGates/Build-TerminologyDictionary.ps1

The writer half of Test-Terminology: it generates one cspell word list per category of the terminology registry, so the spell checker
accepts the registered vocabulary.

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

## One list per category

Each category's terms generate their own word list, so `cspell.yml` can reference and scope them independently
([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)). The category set
is the registry's own `categories` map, the single source, validated by the TerminologyConfig type. Every category's file is always written,
even with no terms, so the generated file set stays stable.

## Content

The accepted tokens are the terms themselves. An abbreviation's expansion is a real word cspell already knows, so it is not registered. Each
list is lower-cased, de-duplicated and sorted by ordinal comparison, so it is deterministic. A head of `#` lines, which cspell reads as
comments, carries the do-not-edit warning that `.cspell/README.md` repeats. The head is part of the content, so drift checks compare it too.

## Where it writes

The lists are `.cspell/<category>.txt` at the repository root, the fixed paths `cspell.yml` names. They are gitignored, generated artifacts
([ADR-REPO-OUTDIR-DICTIONARIESGENERATED](../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated)),
so a fresh clone has no `.cspell/` folder. The writer creates the folder before it writes, because the .NET file write does not.
