---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets:
    [
      pwsh/Catzc.Base.Languages,
      pwsh/Catzc.Base.Docs,
      pwsh/Catzc.Base.QualityGates,
      pwsh/Catzc.Base.Contracts,
      contracts/catzc/0.0.0,
      docs/references/pwsh,
    ]
---

# Generated heads carry with_body_sha only

Decision (user, 2026-10-19): `with_inputs_sha` leaves the generated file heads. No gitignored companion cache replaces it; generated files
are regenerated often, so a skip-on-stamp cache buys nothing and the stamp churned tracked files with no content change. A generator always
renders and lets `Write-FileIfChanged` decide; the only currency fact is `with_body_sha`.

Rules: ADR-PRIN-ONELIVE (delete the mechanism whole, no shim), ADR-REPO-CONTRACT (the contract files change in the same step as the code),
ADR-AUTO-TEST (each file verified before the next), "never drop keys silently" (a removed key gets its meaning written down first).

Context, one line: `pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1` is staged-dirty by another session; coordinate before step 3 touches it.

## Why its value is high

A cache key committed into tracked files is a second source of truth: `with_inputs_sha` churned the heads of `docs/adr/glossary.md` and
`docs/adr/index.md` on any ADR or type edit while the body stayed identical, so every such commit carried noise and no fact.

## Open steps

- [x] **Record the dropped key** — verdict: `docs/references/generated-head-with-inputs-sha-key.md` written (what it was, why it goes, that
      nothing replaces it, ADR-REPO-FILEMETA-IMPRINTEDPARTS absorbs it); Test-Links OK.
- [x] **Five generators** (done before Format-GeneratedFileHead, see below) — verdict: after each edit a fresh full import loaded and its
      test file Passed: Build-Glossary, Build-AdrCodeDictionary, Build-TerminologyDictionary, Build-ContractReference, Build-AdrIndex. Each
      stamp-only comment section left its comment page; the asset-dependency tests now say the registry is named as the source, not stamped.
- [x] **Format-GeneratedFileHead** loses `-InputsSha` — verdict: a fresh full import loads; `Format-GeneratedFileHead.Tests.ps1` Passed (the
      never case also asserts the parameter is gone); the parameter's section left its comment page.
- [ ] **Delete Test-GeneratedFileCurrent whole**: its file, its test, its comment page and its command contract are the user's git rm, set 9
      in `out/run-user-git.ps1`. Nothing depends on them any more (no caller, `Get-InputStamp`'s page re-pointed), and
      `importer-commands.sh` and `docs/references/contracts/catzc.md` regenerate without them on the next import. Check: after the set 9
      run, a fresh import, then `Test-Contracts`.
- [x] **Config and schema** — verdict: `generated-head.yml`, `GeneratedHeadConfig`'s known keys (the type rejects the key, so it leaves the
      type too) and the yml's comment page drop it; `head.schema.json` drops it and gains `warning`, which the generated head writes and the
      schema lacked (a gap that predates this plan). `GeneratedHeadConfig.Tests.ps1` Passed (it now asserts the key is rejected);
      `Format-FileMeta.Contract.Tests.ps1` Passed.
- [x] **Regenerate** in one fresh session — verdict: two rounds of the five generators wrote nothing (the import's janitors had regenerated
      already), and no generated file carries `with_inputs_sha`. `git diff HEAD --stat`: `docs/adr/index.md` and both
      `docs/references/contracts/*.md` pages show exactly one deleted line. `docs/adr/glossary.md` lost its stamp line too, and also shows
      another session's new glossary term. `.cspell` is gitignored. `Get-InputStamp` keeps its root-config caller.
- Ordering, recommended by catzc-08, 2026-10-19: the generators went before Format-GeneratedFileHead lost `-InputsSha`, because
  Build-Glossary and Build-AdrIndex run in the importer janitors. Removing the parameter first would have broken every session's import.

## Not in scope

- `Get-InputStamp` and `Catzc.Base.RootConfig/private/Get-RootConfigInputStamp.ps1` stay as they are.
- No companion cache, no skip path of any kind.
- Commits are the user's.
