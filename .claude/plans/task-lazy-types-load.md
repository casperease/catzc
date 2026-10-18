---
task:
  status: open
  plans: [plan-lazy-types-load]
  value: medium-high
  blocked_on: nothing; D09 decided 2026-10-18
  targets:
    [
      automation/.internal/Catzc.Internal.Bootstrap.psm1,
      automation/.internal/Catzc.Internal.Types.psm1,
      automation/.internal/assets/types-load.yml,
      automation/.compiled,
      docs/adr/automation/BCL/native-csharp-types.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task-lazy-types-load.md"
    folder: plans
    name: task-lazy-types-load
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TYPES#{15,16}
---

# Task: lazy types load, Phases 3 to 5

Phases 0 to 3 are in the tree (types-load.yml with its 27 L0 tests, Test-TypesAssemblyContent, the manifest beside the DLL,
Register-DeferredTypes, Initialize-Types, Enable-DeferredTypesLoad). Warm timings: hash of 253 sources 155 ms, load 41 ms, drift compare 38
ms. The policy is read while the DLL is unloaded, so its default lives once in `$script:TypesLoadDefault` in the Types module, an exception
to ADR-AUTO-DEFAULT#6 that the ADR records. Only pwsh loads the DLL (ADR-AUTO-ENGINE#1); headless cells are eager (ADR-AUTO-TYPES#15).

## Steps

1. [x] D09 janitors: if "after the first prompt", `Invoke-ImporterJanitors` moves behind the console prompt hook so a source-console import
       stays lazy until a command runs; if "keep", record that lazy pays off for bundle, `-SkipJanitors` and idle sessions only. One Decided
       line. Check: a `-DiagnoseLoadTime` import shows the DLL not loaded before the first prompt, or the line exists. Decided 2026-10-18
       (D09): after the first prompt. Done 2026-10-18: `Invoke-Importer` routes a console import (no caller script, not a pipeline) without
       `-CleanClone` through `Enable-DeferredJanitors`; a headless import, every `pwsh -File` run included, keeps the janitors inline, and a
       `-CleanClone` import runs them inline so the clean happens at import. Proof in a fresh `pwsh -Command` session
       (`out/t-lazy-proof.ps1`, `out/t-lazy-probe.ps1`): the pending types record reads `loaded=False` after the import and after the first
       prompt render, `loaded=True` after the second, when the janitors ran; the prompt is restored and the Importer module is gone again.
       Timings, fresh process: 3.5 s before (three rounds 3.6, 3.5, 3.5 s) to 2.3 s after (2.3, 2.4, 2.3 s); the janitors' 2.9 s is paid at
       the second prompt. The section "Loaded by the first use" of ADR-AUTO-TYPES says so; `ADRREG issues=0`, `LINKS issues=0`,
       `MDLINT issues=0`, `SPELL issues=0`, `GLOSSARY issues=0` on the page.
2. [x] Phase 3 leftover, the console prompt hook: the hook registers once, removes itself after the first load. Test in Initialize-Types
       tests. Check: the test passes. Done 2026-10-18 as `Enable-DeferredJanitors` and `Invoke-DeferredJanitorsPrompt` in
       `Catzc.Internal.Loader` (the module that stays loaded): the hook wraps the global prompt once, leaves the first render untouched, and
       on the second render restores the prompt first, then re-imports the Importer module, runs `Invoke-ImporterJanitors` inside it and
       removes it again. Correction from the tree: the hook is a Loader function, so its test is
       `automation/.internal/tests/Enable-DeferredJanitors.Tests.ps1` (three cases: render then run once then gone, a throwing action leaves
       a working prompt, the default action names the janitors), not a case in Initialize-Types tests. `[Invoke-TestFile] Passed`
       (`out/test-file/20261018-105216-5e9f17`), `ANALYZER issues=0` on the Loader, the Importer and the test; the test file is untracked,
       so `Format-FileMeta` stamps its head after the user's commit (`FILEMETA` reports that one drift until then).
3. [x] Phase 3 leftover, L1 test: through the real importer, after import no `Catzc.*` type is loaded
       (`[AppDomain]::CurrentDomain.GetAssemblies()` lists no Catzc.Types) and the first command loads it. Check: the L1 file passes under
       its limit. Corrected 2026-10-17: the importer derives the host kind from the interactive session, so a test run is headless and eager
       by the policy; the lazy path is proven where it can be, in `Import-CSharpTypes.Tests.ps1` ('verifies but does not load the types for
       a console host, and the first Initialize-Types loads them', plus the bundle and eager cases) with `-HostKind console` on a fixture.
       Nothing to add.
4. Phase 4: a stat-stamp memo in front of `Get-CombinedTypeHash`: the hash is recomputed only when any `types/*.cs` mtime or size changed
   since the stamp beside the manifest; the janitor and `Clear-CompiledType` treat stamp, manifest and DLL as one build. Tests. Check: a
   warm import measures the saving (record the ms before and after in the plan). 2026-10-17, corrected on two points: `.compiled` is tracked
   (the DLL and manifest are committed) and the memo holds machine-local lengths and write times, so it lives beside the shadow copies
   (`Get-TypesShadowRoot`, one `stamp-<root digest>.json` per modules root), and it is self-validating per file, so the janitor and
   `Clear-CompiledType` need not know it. `Get-CombinedTypeHash -StampPath` is opt-in; only `Import-CSharpTypes` passes it, and never for a
   bundle; every other caller hashes every file as before. Done 2026-10-17 as `Get-CombinedTypeHash -StampPath` plus `Get-TypesStampPath`
   with `Get-CombinedTypeHash.Tests.ps1` (`[Invoke-TestFile] Passed`, `out/test-file/20261017-204031-ab7e25`). Measured warm, in one process
   over the 284 sources: the hash call falls from about 100 ms to 51 ms with the memo (`out/t025-b.ps1`, three rounds, same hash); the
   import's "types (combined)" stage does not move, 203 ms before and 207 to 212 ms after (`out/t025-c.ps1`), so the stage is paid
   elsewhere: the namespace check reads every source again, then the drift compare and the metadata verification. The next lever, if the
   stage matters, is to run the namespace check only over the files the memo rehashed.
5. [x] Phase 5 ADR: `docs/adr/automation/BCL/native-csharp-types.md` gains the rule that the importer never loads the types assembly and the
       first use does; drift rules #7 and #15 kept; the default-declaration exception recorded in present tense. `Build-AdrIndex`. Check:
       Test-AdrRegistry, Test-Links. Done 2026-10-17: ADR-AUTO-TYPES#16 with the section "Loaded by the first use" and an enforcement
       bullet; `ADRREG issues=0`, `NEUTRAL issues=0`, `LINKS issues=0`, `MDLINT issues=0`, `SPELL issues=0` (`out/t025-b.ps1`,
       `out/t025-c.ps1`).
6. [x] Comment pages of the touched Bootstrap and Types functions regenerated (Export-Comments); the 8-cell `types-load.yml` documented with
       its default declared once. Check: Test-Comments, Test-GeneratedFiles clean. Done 2026-10-17: the comments imprint step of
       `Format-Code` ran over both modules, Test-Comments reports nothing under `.internal` (10 findings, all peers'); `types-load.yml`
       already says a key left out takes the default declared in `Get-TypesLoadPolicy`.
7. [x] Bundle lazy-install test: the exported bundle carries the manifest and loads lazily in a console cell. Check: the bundle test passes.
       In the tree before this task: `Assert-CatzcBundle.Tests.ps1` throws when the manifest is missing or misnamed, and
       `Import-CSharpTypes.Tests` 'defers a console bundle load too, from the prebuilt DLL and manifest, without compiling'. Both files ran
       green here apart from the one `Test-BuildArtifact` case that waits for the user's commit of the rebuilt `.compiled` DLL.
8. [x] Delete any remaining eager path (one living version); `shadowCopy: false` on Unix recorded as unconfirmed if no Unix run exists.
       Check: grep for the old eager Add-Type path finds nothing outside the eager cells. Done 2026-10-17: the only `Add-Type` calls are the
       build (`Build-CombinedTypeAssembly`) and the one load (`Import-TypesAssembly`, in place or from the shadow copy); eager is
       `Initialize-Types` at import, no second path. `shadowCopy: false` on Unix stays unconfirmed, no Unix run exists.
9. [x] Tick the plan's steps; it is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero. 2026-10-18: the Phase 3 leftover is
       ticked with the hook; the plan's open-step grep counts zero, and task-closing-sweep deletes it.

## Report

As report-fixed, with the before and after timings.
