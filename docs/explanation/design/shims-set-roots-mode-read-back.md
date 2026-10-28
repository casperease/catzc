# Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it

```text
Each entry script fixes the code root, and Get-CatzcRunMode reads the mode back from it.

1   importer.ps1                  the source-mode shim; sets RepositoryRoot, calls Invoke-Importer
2   <RepositoryRoot>/pwsh   the code root without -Bundle
3   Import-Catzc.ps1              the build-mode initializer; sets CatzcModulesRoot to its own folder
4   Catzc/<v>                     the code root with -Bundle: the package folder
5   Invoke-Importer               the one living load function; fixes CatzcModulesRoot for the load
6   Get-CatzcRunMode              compares the code root with <RepositoryRoot>/pwsh
7   Import-VendorModules          loads the vendored modules from the root's .vendor/
8   Import-AllModules             evicts the other root, loads the C# types, imports every module
9   Assert-CatzcRunModeExclusive  the last load step: every loaded catzc module is under the root
10  Exclusivity violated          the throw, naming each offending module and both roots

Supports DDR-RUNMODE-TWORUNMODES, DDR-RUNMODE-MODEISDERIVED, DDR-RUNMODE-NEVERCOEXIST and DDR-RUNMODE-THREEBUILDKINDS (implementation lens).
```

The two entry scripts of cats, one per run mode, are both thin. Each one only fixes the roots and then calls the same function,
`Invoke-Importer`, which runs one load sequence in both modes and hands the code root on to every step of it. Because the mode is read back
from that same code root, the mode a session reports cannot disagree with the code it actually loaded.

```yml drawio
description:
  Each entry script only fixes the code root and calls the one importer function, which hands the root to three load steps and reads the run
  mode back from the same root; a foreign module left loaded stops the load.
about:
  rules: [DDR-RUNMODE-TWORUNMODES, DDR-RUNMODE-MODEISDERIVED, DDR-RUNMODE-NEVERCOEXIST, DDR-RUNMODE-THREEBUILDKINDS]
  lens: implementation
content:
  title: Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-source, label: SOURCE }
    - { id: band-build, label: BUILD }
    - { id: band-invoke, label: INVOKE-IMPORTER }
    - { id: band-load, label: LOAD SEQUENCE }
  groups:
    - { id: grp-load, label: load steps in order, in: band-load }
  glyphs:
    - { id: g-importer, kind: code, label: importer.ps1, in: band-source }
    - { id: g-source-root, kind: store, label: <RepositoryRoot>/pwsh, in: band-source }
    - { id: g-import-catzc, kind: code, label: Import-Catzc.ps1, in: band-build }
    - { id: g-bundle-root, kind: store, label: Catzc/<v>, in: band-build }
    - { id: g-invoke, kind: code, label: Invoke-Importer, in: band-invoke }
    - { id: g-run-mode, kind: code, label: Get-CatzcRunMode, in: band-invoke }
    - { id: g-vendor, kind: code, label: Import-VendorModules, in: grp-load }
    - { id: g-all, kind: code, label: Import-AllModules, in: grp-load }
    - { id: g-exclusive, kind: gate, label: Assert-CatzcRunModeExclusive, in: grp-load }
    - { id: f-exclusivity, kind: failure, label: Exclusivity violated, in: band-load }
  edges:
    - { from: g-importer, to: g-source-root, kind: flow, label: "" }
    - { from: g-import-catzc, to: g-bundle-root, kind: flow, label: "" }
    - { from: g-source-root, to: g-invoke, kind: flow, label: feeds }
    - { from: g-bundle-root, to: g-invoke, kind: flow, label: feeds }
    - { from: g-invoke, to: g-run-mode, kind: flow, label: calls }
    - { from: g-invoke, to: grp-load, kind: flow, label: "" }
    - { from: g-exclusive, to: f-exclusivity, kind: fail, label: "" }
  markers:
    - { at: g-importer, number: 1 }
    - { at: g-source-root, number: 2 }
    - { at: g-import-catzc, number: 3 }
    - { at: g-bundle-root, number: 4 }
    - { at: g-invoke, number: 5 }
    - { at: g-run-mode, number: 6 }
    - { at: g-vendor, number: 7 }
    - { at: g-all, number: 8 }
    - { at: g-exclusive, number: 9 }
    - { at: f-exclusivity, number: 10 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-source: { x: 20, y: 84, w: 380, h: 210 }
  band-build: { x: 420, y: 84, w: 860, h: 210 }
  band-invoke: { x: 20, y: 314, w: 1260, h: 100 }
  band-load: { x: 20, y: 434, w: 1260, h: 180 }
  g-importer: { x: 80, y: 130, w: 260, h: 44 }
  g-source-root: { x: 80, y: 220, w: 260, h: 56 }
  g-import-catzc: { x: 600, y: 130, w: 280, h: 44 }
  g-bundle-root: { x: 600, y: 220, w: 280, h: 56 }
  g-invoke: { x: 380, y: 350, w: 300, h: 44 }
  g-run-mode: { x: 900, y: 350, w: 280, h: 44 }
  grp-load: { x: 60, y: 470, w: 780, h: 130 }
  g-vendor: { x: 80, y: 528, w: 200, h: 44 }
  g-all: { x: 310, y: 528, w: 200, h: 44 }
  g-exclusive: { x: 540, y: 508, w: 280, h: 84 }
  f-exclusivity: { x: 960, y: 528, w: 280, h: 44 }
```

![Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it](.assets/shims-set-roots-mode-read-back.drawio.png)

## Walkthrough

1. **importer.ps1.** The repository-root shim is generated by `New-Importer`. It sets `$env:RepositoryRoot = $PSScriptRoot`, loads the
   internal loader, and calls `Invoke-Importer` with its own parameters. A fresh tree starts from a seed form of the file in
   `Catzc.Base.RootConfig/assets/root/`, which replaces itself with the generated shim on first load.
2. **`<RepositoryRoot>/pwsh`.** Called without `-Bundle`, `Invoke-Importer` sets `CatzcModulesRoot` to `<RepositoryRoot>/pwsh`, so the
   source tree is the code root.
3. **Import-Catzc.ps1.** The package initializer sets `RepositoryRoot` from its `-RepositoryRoot` parameter, else keeps the value already
   set, else uses the current location. It then sets `$env:CatzcModulesRoot = $PSScriptRoot` and calls `Invoke-Importer -Bundle`. The build
   copies this file into every package.
4. **`Catzc/<v>`.** With `-Bundle`, the importer keeps the preset code root, so the root is whichever package folder the initializer sits
   in. `Build-Modules` writes a temporary build under `out/pwsh/built/<bundle>/Catzc/<v>/`, `Install-Catzc -Scope CurrentUser` copies it to
   the user module path, and `Install-Catzc -Root` copies it to `<Root>/.vendor/Catzc/<v>/`.
5. **Invoke-Importer.** The one living load function sets the session preferences (errors and warnings stop, information shows), then fixes
   `CatzcModulesRoot` for the rest of the load and loads its internal Bootstrap, Types and Vendor modules. It hands the code root to the
   three load steps below, which run in order from left to right.
6. **Get-CatzcRunMode.** It compares the full path of `CatzcModulesRoot` with `<RepositoryRoot>/pwsh`, ignoring case and a trailing
   separator, and answers `source` when they match and `build` otherwise. It reads back exactly the root the importer set.
7. **Import-VendorModules.** The vendored modules load from the active root's `.vendor/` folder.
8. **Import-AllModules.** It evicts every catzc module loaded from another root, loads the C# types, and then imports every module from the
   active root.
9. **Assert-CatzcRunModeExclusive.** The importer's last load step checks that every loaded catzc module, the internal ones included, has
   its base under the active code root.
10. **Exclusivity violated.** If any module comes from another root, the assert throws, naming each offending module and both roots.

## Why it holds

- Source mode is entered by `importer.ps1` and build mode by the package's `Import-Catzc.ps1` (DDR-RUNMODE-TWORUNMODES).
- The mode is derived from the code root and never stored, so it cannot disagree with what loaded (DDR-RUNMODE-MODEISDERIVED).
- Entering either mode removes every module loaded from the other root, then asserts that every loaded catzc module comes from the active
  root (DDR-RUNMODE-NEVERCOEXIST).
- Every kind of build root loads through the same importer (DDR-RUNMODE-THREEBUILDKINDS).

## Where the code and the decision record differ

The DDR says the importer evicts the other mode before it loads a root. The eviction runs inside `Import-AllModules`, after the preferences
and the vendored modules have loaded.

## See also

- [Run modes: source mode and build mode](../../drs/design/run-modes.md) — the decision this article explains.
- The other lenses on the same modes: [meta](where-code-loads-from-decides-the-mode.md),
  [architecture](two-roots-one-importer-same-modules.md), [operations](one-entry-script-per-mode.md) and
  [governance](which-run-mode-rules-have-a-gate.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
