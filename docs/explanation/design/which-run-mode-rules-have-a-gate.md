# Run-mode rules 1 to 6 each have a gate; rule 7's build kinds need none

```text
Run-mode rules 1 to 6 each have a gate; rule 7's build kinds need none.

1  Test-Automation               the source run: rules 2, 3 and 6
2  Test-CatzcBuild               the build run: rules 3 and 6
3  importer.ps1                  the source-mode entry: rule 1
4  Assert-CatzcRunModeExclusive  the last load step: rule 5
5  Import-Catzc.ps1              the build-mode entry: rule 1
6  Assert-SourceTree             source-tree tools fail fast in a build: rule 2
7  Get-CatzcRunMode              derives the mode from the code root: rule 4
8  Three build kinds             temporary, installed and saved, told apart by place: rule 7

Supports DDR-RUNMODE-TWORUNMODES, DDR-RUNMODE-SAMEMODULEINBOTH, DDR-RUNMODE-OWNSCRIPTSCOPE, DDR-RUNMODE-MODEISDERIVED,
DDR-RUNMODE-NEVERCOEXIST, DDR-RUNMODE-SAMETESTSBOTHMODES and DDR-RUNMODE-THREEBUILDKINDS (governance lens).
```

The run-modes DDR makes seven rules about how cats loads its modules from source and from a built package. Six of them are checked by code:
two test runs, two asserts, and the tests behind the mode function. The seventh names three kinds of build root, which the place of the code
root tells apart, so no gate is needed. A reader who wants to know which run-mode promises are enforced finds the gate for each rule here.

```yml drawio
description:
  "Which run-mode rules a gate checks: the two test runs, the two entry scripts, the exclusivity assert, the source-tree assert and the mode
  function cover six rules, and the three build kinds, told apart by place, need none."
about:
  rules:
    - DDR-RUNMODE-TWORUNMODES
    - DDR-RUNMODE-SAMEMODULEINBOTH
    - DDR-RUNMODE-OWNSCRIPTSCOPE
    - DDR-RUNMODE-MODEISDERIVED
    - DDR-RUNMODE-NEVERCOEXIST
    - DDR-RUNMODE-SAMETESTSBOTHMODES
    - DDR-RUNMODE-THREEBUILDKINDS
  lens: governance
content:
  title: Run-mode rules 1 to 6 each have a gate; rule 7's build kinds need none
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-runs, label: TEST RUNS }
    - { id: band-load, label: LOAD }
    - { id: band-after, label: AFTER THE LOAD }
  glyphs:
    - { id: g-test-automation, kind: gate, label: Test-Automation, in: band-runs }
    - { id: g-test-build, kind: gate, label: Test-CatzcBuild, in: band-runs }
    - { id: g-importer, kind: code, label: importer.ps1, in: band-load }
    - { id: g-exclusive, kind: gate, label: Assert-CatzcRunModeExclusive, in: band-load }
    - { id: g-import-catzc, kind: code, label: Import-Catzc.ps1, in: band-load }
    - { id: g-source-tree, kind: gate, label: Assert-SourceTree, in: band-after }
    - { id: g-run-mode, kind: code, label: Get-CatzcRunMode, in: band-after }
    - { id: g-build-kinds, kind: drsonly, label: Three build kinds, in: band-after }
  edges:
    - { from: g-test-automation, to: g-importer, kind: flow, label: calls }
    - { from: g-test-build, to: g-import-catzc, kind: flow, label: calls }
    - { from: g-importer, to: g-exclusive, kind: flow, label: "" }
    - { from: g-import-catzc, to: g-exclusive, kind: flow, label: "" }
    - { from: g-source-tree, to: g-run-mode, kind: flow, label: calls }
  markers:
    - { at: g-test-automation, number: 1 }
    - { at: g-test-build, number: 2 }
    - { at: g-importer, number: 3 }
    - { at: g-exclusive, number: 4 }
    - { at: g-import-catzc, number: 5 }
    - { at: g-source-tree, number: 6 }
    - { at: g-run-mode, number: 7 }
    - { at: g-build-kinds, number: 8 }
  chips:
    - { at: g-test-automation, kind: rule, rule: DDR-RUNMODE-SAMEMODULEINBOTH }
    - { at: g-test-automation, kind: rule, rule: DDR-RUNMODE-OWNSCRIPTSCOPE }
    - { at: g-test-automation, kind: rule, rule: DDR-RUNMODE-SAMETESTSBOTHMODES }
    - { at: g-test-build, kind: rule, rule: DDR-RUNMODE-OWNSCRIPTSCOPE }
    - { at: g-test-build, kind: rule, rule: DDR-RUNMODE-SAMETESTSBOTHMODES }
    - { at: g-importer, kind: rule, rule: DDR-RUNMODE-TWORUNMODES }
    - { at: g-exclusive, kind: rule, rule: DDR-RUNMODE-NEVERCOEXIST }
    - { at: g-import-catzc, kind: rule, rule: DDR-RUNMODE-TWORUNMODES }
    - { at: g-source-tree, kind: rule, rule: DDR-RUNMODE-SAMEMODULEINBOTH }
    - { at: g-run-mode, kind: rule, rule: DDR-RUNMODE-MODEISDERIVED }
    - { at: g-build-kinds, kind: rule, rule: DDR-RUNMODE-THREEBUILDKINDS, gated: false }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-runs: { x: 20, y: 104, w: 1260, h: 130 }
  band-load: { x: 20, y: 254, w: 1260, h: 130 }
  band-after: { x: 20, y: 404, w: 1260, h: 130 }
  g-test-automation: { x: 160, y: 130, w: 200, h: 84 }
  g-test-build: { x: 900, y: 130, w: 200, h: 84 }
  g-importer: { x: 140, y: 300, w: 240, h: 44 }
  g-exclusive: { x: 460, y: 280, w: 340, h: 90 }
  g-import-catzc: { x: 880, y: 300, w: 240, h: 44 }
  g-source-tree: { x: 140, y: 435, w: 240, h: 90 }
  g-run-mode: { x: 500, y: 458, w: 260, h: 44 }
  g-build-kinds: { x: 880, y: 456, w: 240, h: 52 }
```

![Run-mode rules 1 to 6 each have a gate; rule 7's build kinds need none](.assets/which-run-mode-rules-have-a-gate.drawio.png)

## Walkthrough

1. **Test-Automation.** The source run loads every test worker through `importer.ps1`. It runs the whole body of tests, including the parity
   test, which checks that each built module's public and private function sets equal its source folder's, and which carries the
   `source-only` tag. It also runs the scope-isolation test, which proves that two modules never see each other's `$script:` value.
2. **Test-CatzcBuild.** The build run builds the tested modules, then loads every test worker through the build's `Import-Catzc.ps1`. It
   runs the same test files, skipping only those tagged `source-only`, so the scope-isolation test's in-session check runs in the build as
   well.
3. **importer.ps1.** The source-mode entry script. It is the first of the two entry points that rule 1 names.
4. **Assert-CatzcRunModeExclusive.** Both entry scripts end in the same importer, and the importer's last step is this assert. It throws
   when any loaded catzc module comes from outside the active code root. Its own tests, and an L2 test that switches a session between two
   roots and back, check it.
5. **Import-Catzc.ps1.** The build-mode entry script, the second entry point of rule 1. The package's `Catzc.psm1` dot-sources it, so
   `Import-Module Catzc` enters the same way.
6. **Assert-SourceTree.** Tools that work on the source tree call this assert first. It calls `Get-CatzcRunMode` and throws in a build, so
   such a tool fails fast instead of reading the wrong tree.
7. **Get-CatzcRunMode.** The mode is derived from the code root: `source` when it is the repository's `pwsh/` folder, `build` anywhere else.
   Its tests run in both runs.
8. **Three build kinds.** The DDR names three kinds of build root, temporary, installed and saved, told apart by where the code root lives.
   The kind is never stored and no function reports it, since nothing needs it, so the rule needs no gate.

## Why it holds

- Cats runs in exactly two modes, each with its own entry script (DDR-RUNMODE-TWORUNMODES). Both test runs load their workers through those
  entry scripts.
- Every module is the same module in both modes (DDR-RUNMODE-SAMEMODULEINBOTH). The parity test and `Assert-SourceTree` check it, and the
  analyzer rule `Measure-NoScriptRootAnchor` keeps module code from anchoring on its own file's folder.
- Each module keeps its own script scope in both modes (DDR-RUNMODE-OWNSCRIPTSCOPE). The scope-isolation test checks it.
- The mode is derived, never stored (DDR-RUNMODE-MODEISDERIVED). `Get-CatzcRunMode` derives it, and its tests check the derivation.
- The two modes never coexist in one session (DDR-RUNMODE-NEVERCOEXIST). `Assert-CatzcRunModeExclusive` checks it at the end of every load.
- Both modes are tested by the same tests, and a test leaves the build run only through the `source-only` tag
  (DDR-RUNMODE-SAMETESTSBOTHMODES).
- Build mode has three kinds of root, told apart by where the code root lives (DDR-RUNMODE-THREEBUILDKINDS). No code reports the kind.

## Where the code and the decision record differ

- The DDR says switching is tested from source to build, from build to source, each mode twice and in a longer alternation, each time
  asserting the derived mode. The switch test uses two fixture roots instead, and checks eviction and a fresh script scope, but not the
  derived mode.
- `Measure-NoScriptRootAnchor` cites ADR-PWSH-PWD-MODULELOCATESCONTENT and the internal-asset-dependencies rule
  (ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY), not a run-mode rule; the rules agree.

## See also

- [Run modes: source mode and build mode](../../drs/design/run-modes.md) — the decision this article explains.
- The other lenses on the same modes: [meta](where-code-loads-from-decides-the-mode.md),
  [architecture](two-roots-one-importer-same-modules.md), [implementation](shims-set-roots-mode-read-back.md) and
  [operations](one-entry-script-per-mode.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
