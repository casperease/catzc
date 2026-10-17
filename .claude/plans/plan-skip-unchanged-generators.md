---
plan:
  status: open
  value: medium
  reviewed: 2026-10-17
  targets:
    [
      automation/Catzc.Base.Files,
      automation/Catzc.Base.Languages,
      automation/Catzc.Base.Docs,
      automation/Catzc.Base.RootConfig,
      automation/.internal,
    ]
catzc:
  immutable:
    with_body_sha: "3e70e8cf0b3e"
    repo_status: clean
    path: ".claude/plans/plan-skip-unchanged-generators.md"
    folder: plans
    name: plan-skip-unchanged-generators
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Skip unchanged inputs in the import-time generators

The importer's session finalizer ran about 3 s, of which about 2.8 s was the generators (`Invoke-ImporterJanitors`), each rebuilding
checked-in outputs on an unchanged tree. A generator now stamps its inputs into the head of the file it writes (`with_inputs_sha`) and skips
when the stamp is current. Landed, tested per file:

- `Get-InputStamp` over the compiled `Catzc.Base.Files.InputStamp`: one SHA-256 over sorted (relative path, CR-stripped content hash), the
  same on every checkout; `-Exclude` for the generator's own output and the pages generated beside it.
- `Format-GeneratedFileHead -InputsSha`, the `with_inputs_sha` head key, `Test-GeneratedFileCurrent`.
- Wired: `Build-Glossary`, `Build-AdrIndex` (about 16 and 38 ms on a skip), `Build-TerminologyDictionary` (10 ms), `Build-ContractReference`
  (5 ms).

## Open

Janitor times measured 2026-10-17 on an unchanged tree (noisy, machine busy): wired ones 25 to 67 ms each (about 180 ms together); unwired
`Build-RootConfig` 562 ms, `Sync-SessionTools` 403 ms, `Build-Readme` 315 ms, `Build-GitKeep` 312 ms. The importer finalizer showed 2.6 s,
the rest being the two unprofiled janitors and import overhead.

1. `Build-Readme` (315 ms cold, 107 ms warm, profiled with `out/profile-readme.ps1`): the 58 mappings cost 15 ms to list, 22 ms for
   `Get-FileKind`, 33 ms to strip front matter, 36 ms to rebase links and about 30 ms to compare and write. Nothing dominates, and about 200
   ms of the 315 is the first call in a session (loading and JIT), which a stamp skip would only partly avoid. Not worth a format change to
   55 committed files; at most the front-matter strip could move into the compiled rebaser for about 30 ms. Recorded as not skippable. The
   inputs, were it ever wanted, are known and small (`readme.yml`, each mapping's source doc, `Get-ReadmeMappings`, `Get-ReadmeContent`,
   `MarkdownLinkRebaser`, the folder listing for the `automation/*` glob), but a README has no head to hold a stamp: its meta block is only
   `kind: readme`. A stamp would add a key to about 55 committed README copies and touch `Test-GeneratedReadmes` and the meta gates. Decide
   first: stamp into the README meta block, or profile where the 315 ms goes (mapping glob, `Get-FileKind` per folder, the link rebase) and
   cut that instead.
2. `Build-RootConfig` (562 ms): not safe from declared `sources`. Wildcard entries scan the tree and `.gitattributes` is built from more
   than its two listed files, so a missed input leaves a root file stale with the stamp saying current. Needs its full input set, or a stamp
   over the tree it scans.
3. `Build-GitKeep` (125 ms): depends on the folder structure, so it has the same problem as `Build-RootConfig`.
4. `Sync-SessionTools` (343 ms): not a generated file, so the head stamp does not apply; it needs its own skip check.
5. `Invoke-TypeCacheJanitor` and `Invoke-AgentHookJanitor` costs are unprofiled.
6. New files still to run through `Format-FileMeta` (heads, reference pages), the `.psd1` `CatzcFiles` regeneration, and the meta gates.

## Done when

The janitors' total on an unchanged tree is measured again with `out/profile-janitors.ps1` and each remaining generator is either wired with
its inputs proven complete or recorded here as not skippable.
