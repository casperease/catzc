# Drop a file, and the next import exports it

```text
Drop a file, and the next import exports it; no registration step exists.

1  Verb-Noun.ps1               the one file the author adds
2  . ./importer.ps1            the import: regenerates every manifest
3  Verb-Noun exported          a root function is exported
4  Function name collision(s)  a duplicate or shadowing name throws first
5  Get-ModuleGlobSet           returns the module's two aspect sets
6  In <kebab>-live             the new file is in the live set: it ships
7  Quality gates               report a non-conventional folder or file

Supports DDR-ASPECT-MODULESPARTITIONED and DDR-ASPECT-ASPECTSAREDERIVED (operations lens).
```

Adding a function to a cats module has no registration step. The author drops a `Verb-Noun.ps1` file into the module folder, the next import
exports it, and `Get-ModuleGlobSet` shows that the file belongs to the module's live aspect. The importer and the quality gates do the rest,
and each failure they raise names the file or function at fault.

```yml drawio
description:
  "A dropped Verb-Noun file needs no registration: the next import exports it, or throws on a name collision, the module's aspect sets place
  it in the live set, and the quality gates report a non-conventional file."
about:
  rules: [DDR-ASPECT-MODULESPARTITIONED, DDR-ASPECT-ASPECTSAREDERIVED]
  lens: operations
content:
  title: Drop a file, and the next import exports it
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-file, label: THE FILE }
    - { id: band-import, label: EVERY IMPORT }
    - { id: band-aspect, label: WHICH ASPECT }
  glyphs:
    - { id: c-file, kind: code, label: Verb-Noun.ps1, in: band-file }
    - { id: g-quality, kind: gate, label: Quality gates, in: band-file }
    - { id: c-importer, kind: code, label: . ./importer.ps1, in: band-import }
    - { id: r-exported, kind: result, label: Verb-Noun exported, in: band-import }
    - { id: f-collision, kind: failure, label: Function name collision(s), in: band-import }
    - { id: c-globset, kind: code, label: Get-ModuleGlobSet, in: band-aspect }
    - { id: r-live, kind: result, label: in <kebab>-live, in: band-aspect }
  edges:
    - { from: c-file, to: c-importer, kind: flow, label: feeds }
    - { from: c-importer, to: r-exported, kind: flow, label: "" }
    - { from: c-importer, to: f-collision, kind: fail, label: "" }
    - { from: c-file, to: c-globset, kind: flow, label: feeds }
    - { from: c-globset, to: r-live, kind: flow, label: "" }
    - { from: c-file, to: g-quality, kind: flow, label: "" }
  markers:
    - { at: c-file, number: 1 }
    - { at: c-importer, number: 2 }
    - { at: r-exported, number: 3 }
    - { at: f-collision, number: 4 }
    - { at: c-globset, number: 5 }
    - { at: r-live, number: 6 }
    - { at: g-quality, number: 7 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-file: { x: 20, y: 84, w: 240, h: 400 }
  band-import: { x: 280, y: 84, w: 540, h: 400 }
  band-aspect: { x: 840, y: 84, w: 440, h: 400 }
  c-file: { x: 40, y: 140, w: 200, h: 220 }
  g-quality: { x: 60, y: 390, w: 160, h: 72 }
  c-importer: { x: 300, y: 150, w: 200, h: 44 }
  r-exported: { x: 560, y: 150, w: 240, h: 44 }
  f-collision: { x: 560, y: 230, w: 240, h: 44 }
  c-globset: { x: 860, y: 300, w: 190, h: 44 }
  r-live: { x: 1070, y: 300, w: 190, h: 44 }
```

![Drop a file, the next import exports it](.assets/drop-a-file-the-import-exports-it.drawio.png)

## Walkthrough

1. **Verb-Noun.ps1.** The author adds one file, `Verb-Noun.ps1` at the module root or `private/<Verb-Noun>.ps1`. Nothing else is edited: the
   folder is the registration.
2. **. ./importer.ps1.** The importer is dot-sourced and hands over to `Invoke-Importer`, whose `Import-AllModules` regenerates every
   module's manifest on every import.
3. **Verb-Noun exported.** A function at the module root is exported. A function in `private/` is loaded into the module but not exported.
4. **Function name collision(s).** A duplicate exported name, or one that shadows a vendored or built-in command, throws before any module
   loads, with the message "Function name collision(s) detected before import".
5. **Get-ModuleGlobSet.** Run with `-Name <Module>`, it returns both of the module's aspect sets, `<kebab>-live` and `<kebab>-tests`.
6. **In &lt;kebab&gt;-live.** A new root `*.ps1` or `private/` file is in the live set, so it ships. Files in `tests/` and `assets/`, and a
   stray root file that is not a `.ps1`, fall to `<kebab>-tests` and never ship.
7. **Quality gates.** `Test-FolderConventions` reports a subfolder that is "not a conventional module folder (private, tests, assets, types,
   configs)", and a `*.Tests.ps1` dropped at the module root: the loader skips such a file, but it matches the live pattern `*.ps1`, and
   tests belong in `tests/`. `Test-SourceConventions` reports a file that holds more or fewer than one top-level function.

## Why it holds

- A module's files partition into a `live` aspect and a `tests` aspect, with no file in both and none in neither
  (DDR-ASPECT-MODULESPARTITIONED).
- The aspects come from folder conventions, never from a hand-written list; `live` is closed, so a file can enter it only by matching the
  convention (DDR-ASPECT-ASPECTSAREDERIVED).

## Where the code and the decision record differ

ADR-REPO-FOLDERS-UNKNOWNFOLDERSIGNORED says unknown folders are ignored, not errors. The loader does skip them, but `Test-FolderConventions`
reports every non-conventional module subfolder as an issue.

## See also

- [Module aspects](../../drs/design/module-aspects.md) — the decision this article explains.
- The other lenses on the same layout: [meta](every-file-in-exactly-one-aspect.md), [architecture](one-folder-two-independent-readers.md),
  [implementation](manifest-and-aspects-from-one-folder.md) and [governance](partition-integrity-runs-only-in-unit-tests.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
