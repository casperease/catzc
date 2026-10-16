---
plan:
  status: open
  value: medium
  reviewed: 2026-10-17
  targets: [automation/Catzc.Base.Files, automation/Catzc.Base.Languages, automation/Catzc.Base.Docs, automation/Catzc.Base.RootConfig, automation/.internal]
---

# Skip unchanged inputs in the import-time generators

The importer's session finalizer ran about 3 s, of which about 2.8 s was the generators (`Invoke-ImporterJanitors`), each rebuilding
checked-in outputs on an unchanged tree. A generator now stamps its inputs into the head of the file it writes (`with_inputs_sha`) and
skips when the stamp is current. Landed, tested per file:

- `Get-InputStamp` over the compiled `Catzc.Base.Files.InputStamp`: one SHA-256 over sorted (relative path, CR-stripped content hash), the same
  on every checkout; `-Exclude` for the generator's own output and the pages generated beside it.
- `Format-GeneratedFileHead -InputsSha`, the `with_inputs_sha` head key, `Test-GeneratedFileCurrent`.
- Wired: `Build-Glossary`, `Build-AdrIndex` (about 16 and 38 ms on a skip), `Build-TerminologyDictionary` (10 ms), `Build-ContractReference` (5 ms).

## Open

1. `Build-Readme` (175 ms): trace the inputs of each folder mapping (`readme.yml`, the docs sources, the generator helpers) before wiring.
2. `Build-RootConfig` (466 ms): not safe from declared `sources`. Wildcard entries scan the tree and `.gitattributes` is built from more than
   its two listed files, so a missed input leaves a root file stale with the stamp saying current. Needs its full input set, or a stamp over
   the tree it scans.
3. `Build-GitKeep` (125 ms): depends on the folder structure, so it has the same problem as `Build-RootConfig`.
4. `Sync-SessionTools` (343 ms): not a generated file, so the head stamp does not apply; it needs its own skip check.
5. `Invoke-TypeCacheJanitor` and `Invoke-AgentHookJanitor` costs are unprofiled.
6. New files still to run through `Format-FileMeta` (heads, reference pages), the `.psd1` `CatzcFiles` regeneration, and the meta gates.

## Done when

The janitors' total on an unchanged tree is measured again with `out/profile-janitors.ps1` and each remaining generator is either wired
with its inputs proven complete or recorded here as not skippable.
