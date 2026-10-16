---
plan:
  status: active
  class: feature
  value: medium-high
  reviewed: 2026-10-16
  targets:
    [
      automation/.internal/Catzc.Internal.Bootstrap.psm1,
      automation/.internal/Catzc.Internal.Types.psm1,
      automation/.compiled,
      docs/adr/automation/BCL/native-csharp-types.md,
    ]
catzc:
  immutable:
    with_body_sha: b70b976499b7
    repo_status: clean
    path: ".claude/plans/plan-lazy-types-load.md"
    folder: plans
    name: plan-lazy-types-load
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
      - ADR-AUTO-TYPES#{7,15}
---

# Find the types DLL fast, load it only on first use

The importer finds and verifies the compiled types assembly without loading it; the assembly enters the process on the first use of a type.
Phases 0 to 3 are done and checked against the tree (2026-10-17); Phases 4 and 5 are open, plus the Phase 3 leftovers below.

## Why its value is medium-high

Every session pays the hash, shadow copy, Add-Type, verification and registration today, whether or not it uses a type. A session that never
uses a type should never pay the load or hold the shadow copy.

## Needed docs

- native-csharp-types ADR: a new rule that the importer never loads the types assembly; the first use does. Drift rules #7 and #15 kept.
- Comment pages of the touched Bootstrap and Types functions; the 8-cell types-load.yml documented with its default declared once.

## Needed tests

- L0 tests for types-load.yml and the policy resolver, neutral fixture names.
- Test-TypesAssemblyContent on a fixture DLL (metadata-only existence check per type).
- Manifest emitted beside the DLL and treated as one build by the janitor and Clear-CompiledType; bundle ships it.
- Get-LoadedTypeDrift reports not-yet-loaded as not drift.

## Open steps

- [x] Phase 0 measure, spike, `types-load.yml`, `Get-TypesLoadPolicy` (tree: assets/types-load.yml, Types.psm1, its 27 L0 tests).
- [x] Phase 1 metadata verification (`Test-TypesAssemblyContent`, 8 L0 tests).
- [x] Phase 2 manifest (`Catzc.Types.d9f7209b.json` beside the DLL in `.compiled`; Get/Write-TypesAssemblyManifest tests).
- [x] Phase 3 deferred load (`Register-DeferredTypes`, `Initialize-Types`, `Enable-DeferredTypesLoad`; Initialize-Types tests).
- [ ] Phase 3 leftovers: console prompt hook; L1 test of "not loaded after import" through the real importer; decision on source-console
      janitors (below).
- [ ] Phase 4 stat-stamp memo in front of `Get-CombinedTypeHash` (spike: hash 155 ms dominates the 41 ms load, so do it).
- [ ] Phase 5 rules, docs, tests (check: Test-Links, Test-AdrRegistry clean): ADR rule, ADR record of the default-declaration exception,
      comment pages, L1 tests, bundle lazy-install test, delete any remaining eager path.

## Open decisions and facts that remain

- Source-tree console import with janitors on loads the types anyway: the janitors (`Build-AdrIndex`, `Build-Readme`, ...) are public catzc
  commands and trip the lookup hook. Lazy pays off for a bundle, `-SkipJanitors` and idle sessions. Options: run janitors after the first
  prompt, or make them not catzc commands by name. Decision for the user.
- Exception for the ADR: `ADR-AUTO-DEFAULT#6` declares a default on the config type; the policy is read while the types DLL is unloaded, so
  the default row and allowed values live once in `$script:TypesLoadDefault` in the Types module. Record it in the ADR (Phase 5).
- Trigger is a name-filtered `$ExecutionContext.InvokeCommand.PreCommandLookupAction` (a body guard is too late for typed parameters and
  `[OutputType]`; about 7 microseconds per lookup until it removes itself). A literal typed at the console or top of a script before any
  catzc command stays unresolved until `Initialize-Types` or a command runs; headless cells are eager, so that case is closed there.
- Warm timings (2026-10-15): hash of 253 sources 155 ms, shadow copy + prune + `Add-Type` 41 ms, drift compare 38 ms, verify 1 ms; the cold
  path (1.3 s Roslyn) is unaffected by laziness.
- Not shipped yet by Phase 3: the manifest could feed `Test-TypesAssemblyContent` instead of the DLL; `shadowCopy: false` on Unix was
  built (`Import-TypesAssembly -ShadowCopy`) but the janitor and drift guard assumption of a shadow path is unconfirmed on Unix.

## The 8 modes (host x os x run mode)

Only pwsh loads the C# DLL (`ADR-AUTO-ENGINE:1`); bash and zsh answer `load: never`. Settings: `load` (lazy/eager), `trigger`
(lookup-hook/none, none only with eager), `eagerTypes` (empty everywhere), `shadowCopy`. Config and defaults live in
`automation/.internal/assets/types-load.yml`; flip a cell by editing its row, not code. Verification is metadata-only in all eight cells.

| host | os | run mode | load | trigger | shadowCopy |
| --- | --- | --- | --- | --- | --- |
| console | windows | source, build | lazy | lookup-hook | true |
| console | unix | source, build | lazy | lookup-hook | false |
| headless | windows | source, build | eager | none | true |
| headless | unix | source, build | eager | none | false |

Headless is eager so a pipeline fails at import on stale or missing types (`ADR-AUTO-TYPES#15`, `ADR-AUTO-FAILFAST`).

## Refs

- memory: lazy-types-load-plan.md
- docs/adr/automation/BCL/native-csharp-types.md
