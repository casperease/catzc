---
task:
  id: "025"
  status: open
  plans: [plan-lazy-types-load]
  value: medium-high
  blocked_on: D09 for step 1; Phases 4 and 5 can start now
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
    path: ".claude/plans/task025.md"
    folder: plans
    name: task025
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
      - ADR-AUTO-TYPES#15
---

# task025: lazy types load, Phases 3 to 5

Phases 0 to 3 are in the tree (types-load.yml with its 27 L0 tests, Test-TypesAssemblyContent, the manifest beside the DLL,
Register-DeferredTypes, Initialize-Types, Enable-DeferredTypesLoad). Warm timings: hash of 253 sources 155 ms, load 41 ms, drift compare 38
ms. The policy is read while the DLL is unloaded, so its default lives once in `$script:TypesLoadDefault` in the Types module, an exception
to ADR-AUTO-DEFAULT#6 that the ADR records. Only pwsh loads the DLL (ADR-AUTO-ENGINE#1); headless cells are eager (ADR-AUTO-TYPES#15).

## Steps

1. D09 janitors: if "after the first prompt", `Invoke-ImporterJanitors` moves behind the console prompt hook so a source-console import
   stays lazy until a command runs; if "keep", record that lazy pays off for bundle, `-SkipJanitors` and idle sessions only. One Decided
   line. Check: a `-DiagnoseLoadTime` import shows the DLL not loaded before the first prompt, or the line exists.
2. Phase 3 leftover, the console prompt hook: the hook registers once, removes itself after the first load. Test in Initialize-Types tests.
   Check: the test passes.
3. Phase 3 leftover, L1 test: through the real importer, after import no `Catzc.*` type is loaded
   (`[AppDomain]::CurrentDomain.GetAssemblies()` lists no Catzc.Types) and the first command loads it. Check: the L1 file passes under its
   limit.
4. Phase 4: a stat-stamp memo in front of `Get-CombinedTypeHash`: the hash is recomputed only when any `types/*.cs` mtime or size changed
   since the stamp beside the manifest; the janitor and `Clear-CompiledType` treat stamp, manifest and DLL as one build. Tests. Check: a
   warm import measures the saving (record the ms before and after in the plan).
5. Phase 5 ADR: `docs/adr/automation/BCL/native-csharp-types.md` gains the rule that the importer never loads the types assembly and the
   first use does; drift rules #7 and #15 kept; the default-declaration exception recorded in present tense. `Build-AdrIndex`. Check:
   Test-AdrRegistry, Test-Links.
6. Comment pages of the touched Bootstrap and Types functions regenerated (Export-Comments); the 8-cell `types-load.yml` documented with its
   default declared once. Check: Test-Comments, Test-GeneratedFiles clean.
7. Bundle lazy-install test: the exported bundle carries the manifest and loads lazily in a console cell. Check: the bundle test passes.
8. Delete any remaining eager path (one living version); `shadowCopy: false` on Unix recorded as unconfirmed if no Unix run exists. Check:
   grep for the old eager Add-Type path finds nothing outside the eager cells.
9. Tick the plan's steps; it is deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed, with the before and after timings.
