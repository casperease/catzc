# .cspell

Generated cspell dictionaries — **do not edit, do not commit.**

Each `<category>.txt` in this folder is a cspell word list generated from the single source of truth,
[`terminology.yml`](../automation/Catzc.Base.QualityGates/configs/terminology.yml) — the approved-vocabulary registry — by
`Build-TerminologyDictionary` (module `Catzc.Base.QualityGates`). One file is emitted per vocabulary category defined in the registry, and
the root `cspell.yml` references them as separate dictionaries (one `dictionaryDefinition` per category — that list must match the
registry's `categories:`).

## How these files exist

- **Source of truth:** `automation/Catzc.Base.QualityGates/configs/terminology.yml`. Add or remove vocabulary there — never in the generated
  lists.
- **Generator:** `Build-TerminologyDictionary` writes `.cspell/<category>.txt`, each with a `#` header comment naming this source. The
  importer runs it on every load (see `importer.ps1`), so the lists stay current.
- **Gitignored:** the `*.txt` are build artifacts — the local `.gitignore` ignores them; only this `README.md` and that `.gitignore` are
  committed. On a fresh clone, run `. ./importer.ps1` once so the files exist and cspell can resolve them.

A hand-edit is overwritten on the next import. See [spell-out-names](../docs/adr/automation/spell-out-names.md) and
[dedicated-output-directory](../docs/adr/repository/dedicated-output-directory.md) (`out:8`).
