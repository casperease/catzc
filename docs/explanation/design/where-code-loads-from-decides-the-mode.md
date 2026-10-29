# How the run mode is decided

```text
How the run mode is decided.

1  the repository   source mode: every module read in place, one function per file
2  a built package  build mode: the same modules from a package in one of three kinds of place
3  one importer     the one load sequence both modes run
4  same modules     identical in both modes, each with its own script scope
5  the invariant    the mode follows from the code root and the two modes never coexist

Supports DDR-RUNMODE-TWORUNMODES, DDR-RUNMODE-SAMEMODULEINBOTH, DDR-RUNMODE-MODEISDERIVED and DDR-RUNMODE-NEVERCOEXIST (meta lens).
```

Run modes are the two ways cats loads its one set of modules: from the repository, where developers edit one function per file, and from a
built package, which ships to other machines. Both ways go through one importer into the same modules. Nothing records which mode a session
is in. The place the code was loaded from is the answer, so the mode can never disagree with what actually loaded.

```yml drawio
description:
  The repository and a built package are the two places the code loads from; both go through one importer into the same modules, and the
  place it loaded from is the run mode, which nothing stores.
about:
  rules: [DDR-RUNMODE-TWORUNMODES, DDR-RUNMODE-SAMEMODULEINBOTH, DDR-RUNMODE-MODEISDERIVED, DDR-RUNMODE-NEVERCOEXIST]
  lens: meta
content:
  title: How the run mode is decided
  kind: explanation
  flow: top-to-bottom
  theme: dark
  bands:
    - { id: band-source, label: SOURCE }
    - { id: band-build, label: BUILD }
    - { id: band-importer, label: ONE IMPORTER }
    - { id: band-modules, label: SAME MODULES }
  glyphs:
    - { id: g-repository, kind: store, label: the repository, in: band-source }
    - { id: g-package, kind: store, label: a built package, in: band-build }
    - { id: g-importer, kind: code, label: one importer, in: band-importer }
    - { id: g-modules, kind: set, label: same modules, in: band-modules }
  edges:
    - { from: g-importer, to: g-repository, kind: flow, label: reads }
    - { from: g-importer, to: g-package, kind: flow, label: reads }
    - { from: g-importer, to: g-modules, kind: thick, label: "" }
  markers:
    - { at: g-repository, number: 1 }
    - { at: g-package, number: 2 }
    - { at: g-importer, number: 3 }
    - { at: g-modules, number: 4 }
    - { at: band-modules, number: 5 }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-source: { x: 20, y: 84, w: 380, h: 140 }
  band-build: { x: 420, y: 84, w: 860, h: 140 }
  band-importer: { x: 20, y: 244, w: 1260, h: 100 }
  band-modules: { x: 20, y: 364, w: 1260, h: 100 }
  g-repository: { x: 100, y: 125, w: 220, h: 56 }
  g-package: { x: 640, y: 125, w: 440, h: 56 }
  g-importer: { x: 340, y: 280, w: 600, h: 44 }
  g-modules: { x: 440, y: 400, w: 400, h: 44 }
```

![How the run mode is decided](.assets/where-code-loads-from-decides-the-mode.drawio.png)

## Walkthrough

1. **The repository.** Source mode reads every module in place from the repository, one function per file. This is the form for the people
   who edit the code.
2. **A built package.** Build mode reads the same modules from a package. The DDR names three kinds of place a package can sit: temporary,
   installed and saved, and code makes all three.
3. **One importer.** Both modes run the same load sequence: preferences, vendored modules, types and accelerators, then modules.
4. **Same modules.** Each module is identical in both modes, with the same name, functions, configs and assets, and each keeps its own
   script scope.
5. **The invariant.** The mode follows from where the code was loaded from and is never stored, and the two modes never coexist in one
   session.

## Why it holds

- Cats runs in exactly two modes, source and build, each entered by its own entry script (DDR-RUNMODE-TWORUNMODES).
- Every module is the same module in both modes; only its form on disk differs (DDR-RUNMODE-SAMEMODULEINBOTH).
- The mode is derived from the code root, never stored (DDR-RUNMODE-MODEISDERIVED).
- Entering one mode removes every module of the other, so the two never coexist (DDR-RUNMODE-NEVERCOEXIST).

## See also

- [Run modes: source mode and build mode](../../drs/design/run-modes.md) — the decision this article explains.
- The other lenses on the same modes: [architecture](two-roots-one-importer-same-modules.md),
  [implementation](shims-set-roots-mode-read-back.md), [operations](which-entry-script-each-run-mode-uses.md) and
  [governance](which-run-mode-rules-have-a-gate.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
