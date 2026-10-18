# One module folder has two independent readers

```text
One module folder has two independent readers: the loader and the globs engine.

1  pwsh/<Module>/             the folder that is the module
2  Catzc.Internal.Bootstrap   the loader: derives the manifest on every import
3  <Module>.psd1              the derived manifest: generated, gitignored
4  Catzc.Base.Variants        holds the aspects variant, read through Get-Aspect
5  Catzc.Base.Globs           the globs engine: one set per aspect
6  <module>-live              the first aspect, a closed convention: ships
7  <module>-tests             the last aspect, the ** remainder: never ships
8  Aspect sha locks           ADR-only: one immutable lock per aspect

Supports ADR-DSGN-ASPECT-MODULESPARTITIONINTOASPECTS, ADR-DSGN-ASPECT-ASPECTSAREDERIVED and ADR-DSGN-ASPECT-ASPECTISAGLOBSET (architecture lens).
```

A cats module is a folder under `pwsh/`, and nothing else declares what it contains. Two components read that folder, and neither reads the
other: the loader decides what a module exports, and the globs engine decides which of its files ship. Both decisions come from where a file
sits, so a module author shapes visibility and shipping identity with the same act, placing a file.

![One folder, two independent readers](.assets/one-folder-two-independent-readers/diagram.drawio.png)

The diagram is described element by element in [its asset description](.assets/one-folder-two-independent-readers/diagram.drawio.md).

## Walkthrough

1. **pwsh/&lt;Module&gt;/.** The folder is the module. Both readers start from it, and the location of each file inside it is all either of
   them needs.
2. **Catzc.Internal.Bootstrap.** The loader. On every import its `Import-AllModules` derives each module's manifest from the folder. It
   never reads the `aspects` variant.
3. **&lt;Module&gt;.psd1.** The derived manifest. A `.ps1` file at the module root is exported; a file in `private/` is loaded into the
   module but not exported. The manifest is generated and gitignored, never written by hand.
4. **Catzc.Base.Variants.** It holds the `aspects` variant, the ordered first-match convention that names the aspects. The globs engine
   reads it through `Get-Aspect`.
5. **Catzc.Base.Globs.** The globs engine compiles the aspect convention onto each module folder with `AspectPartition`, by first match, and
   derives one set per aspect. It never reads the manifest.
6. **&lt;module&gt;-live.** The first aspect, a closed convention: root `*.ps1`, `private/**`, `types/**` and `configs/**`. It is what
   ships.
7. **&lt;module&gt;-tests.** The last aspect, the `**` remainder: everything the live convention does not claim. It also takes the module's
   Go, Python and Bash test folders, which sit outside the module folder. It never ships.
8. **Aspect sha locks.** The ADR makes each aspect an immutable sha lock, versioned on its own, and never one lock for the whole module. The
   code keeps a separate derived set per aspect but writes no lock or marker file.

## Why it holds

- Every module partitions its tracked files into aspects that are disjoint and exhaustive: no file in two aspects, no file in none
  (ADR-DSGN-ASPECT-MODULESPARTITIONINTOASPECTS).
- Aspects are derived from folder conventions, never declared by hand; ordered first match with a `**` remainder makes the partition true by
  construction (ADR-DSGN-ASPECT-ASPECTSAREDERIVED).
- Each aspect is its own versioned artifact, so a test-only change never re-keys `live` and a runtime change never re-keys `tests`
  (ADR-DSGN-ASPECT-ASPECTISAGLOBSET).

## Where the code and the ADR differ

- ADR-DSGN-ASPECT-ASPECTISAGLOBSET makes each aspect a sha lock with a `<unit>-<aspect>.yml` marker by way of
  ADR-FLOW-CD-GLOBS-CHANGECOMPUTEDFROMGIT, but that rule computes change from git at real refs, never from a committed hash, and no aspect
  marker exists.
- ADR-DSGN-ASPECT-ASPECTSAREDERIVED prefixes every aspect pattern with the unit root, but the tests set also reaches the language test
  folders outside it.

## See also

- [Module aspects](../../adr/design/module-aspects.md) — the decision this article explains.
- The other lenses on the same layout: [meta](every-file-in-exactly-one-aspect.md),
  [implementation](manifest-and-aspects-from-one-folder.md), [operations](drop-a-file-the-import-exports-it.md) and
  [governance](partition-integrity-runs-only-in-unit-tests.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
