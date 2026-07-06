# The cspell dictionary folder

Generated cspell word lists — **do not edit, do not commit.**

Each `<category>.txt` in `.cspell/` is a cspell dictionary generated from the single source of truth,
[`terminology.yml`](../../automation/Catzc.Base.QualityGates/configs/terminology.yml) — the approved-vocabulary registry — by
`Build-TerminologyDictionary` (module `Catzc.Base.QualityGates`). One file is emitted per vocabulary category defined in the registry, and
the root `cspell.yml` references them as separate dictionaries (one `dictionaryDefinition` per category — that list must match the
registry's `categories:`).

## How these files exist

- **Source of truth:** `automation/Catzc.Base.QualityGates/configs/terminology.yml`. Add or remove vocabulary there — never in the
  generated lists.
- **Generator:** `Build-TerminologyDictionary` writes `.cspell/<category>.txt`, each with a `#` header comment naming this source. The
  importer runs it on every load (see `importer.ps1`), so the lists stay current.
- **Everything here is generated:** the word lists are ignored by the folder's `.gitignore`, which is itself a managed root-config copy
  (see [generated-root-configs](../adr/repository/generated-root-configs.md)), and the folder's `README.md` is a generated link to this
  article (see [generated-readmes](../adr/repository/generated-readmes.md)). Only the `.gitkeep` keeping the folder tracked is committed.
  On a fresh clone, run `. ./importer.ps1` once so the files exist and cspell can resolve them.

A hand-edit is overwritten on the next import. See [spell-out-names](../adr/automation/powershell/spell-out-names.md) and
[dedicated-output-directory](../adr/repository/dedicated-output-directory.md) (`ADR-OUTDIR:8`).
