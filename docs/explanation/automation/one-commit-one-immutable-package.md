---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/automation/one-commit-one-immutable-package.md
    folder: docs/explanation/automation
    name: one-commit-one-immutable-package
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-BUNDLE#{1,5,6}
      - ADR-DSGN-RUNMODE#7
    links:
      - docs/adr/automation/platform-bundle.md
      - docs/adr/design/run-modes.md
      - docs/explanation/.assets/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.png
      - docs/explanation/automation/build-then-place-with-one-command.md
      - docs/explanation/automation/build-verify-then-copy-the-folder.md
      - docs/explanation/automation/every-code-root-is-a-copy.md
      - docs/explanation/automation/index.md
      - docs/explanation/automation/one-commit-one-immutable-package.drawio.md
      - docs/explanation/automation/what-gates-each-bundle-stage.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# One commit becomes one verified, immutable package, and every code root is a copy of it

```text
One commit becomes one verified, immutable package, and every code root is a copy of it.

1  Selected modules         the input: modules named or profiled, closure-expanded
2  One build                writes the runtime payload in merged form
3  Integrity check          recomputes the recorded content hash, collects every violation
4  Temporary build          one versioned package under out/, the same bytes per commit
5  Installed, saved         every other code root, a copy of the same package
6  Checked again            the integrity check runs on the package before a copy is placed

Supports ADR-AUTO-BUNDLE#1, #5 and #6, and ADR-DSGN-RUNMODE#7 (meta lens).
```

A bundle is how cats leaves the repository it is developed in: the selected modules are built once into one versioned package that loads
anywhere. The idea fits in one line. One build of one commit produces one package with one content hash, an integrity check proves the
package is what the build wrote, and every place the package is installed holds a copy of those same bytes.

![One commit, one verified, immutable package](../.assets/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.png)

The diagram is described element by element in [its asset description](one-commit-one-immutable-package.drawio.md).

## Walkthrough

1. **Selected modules.** The input is a set of modules, named explicitly, by a profile, or both. The set is closure-expanded, so every
   module a selected module depends on comes along.
2. **One build.** The build writes the runtime payload in merged form: one manifest and one merged function file per module, beside the
   loader, the vendored dependencies and the full types DLL. Tests never ship.
3. **Integrity check.** The check recomputes the content hash the build recorded and collects every violation before it fails. The build
   runs it on its own output, so a package that leaves the build has passed it.
4. **Temporary build.** The result is one versioned package under `out/`, the code root of build mode on a devbox. The same commit yields
   the same build and one content hash, so the package is immutable.
5. **Installed, saved.** Every other code root is a copy of the same package: installed into a module path, or saved into another root's
   `.vendor/`. The copy carries the same bytes and the same content hash.
6. **Checked again before placement.** Before a copy is placed, the integrity check runs once more on the package being copied, so a package
   that changed after its build is never installed or saved.

## Why it holds

- A bundle is one installable, versioned module built from a selected set of modules, closure-expanded over the declared dependencies, that
  loads outside the repository (ADR-AUTO-BUNDLE#1).
- A build is immutable and content-addressed: the same commit yields a byte-identical build and an identical content hash, and the integrity
  guard re-verifies that hash (ADR-AUTO-BUNDLE#5).
- An install verifies the source build before it touches the destination, and a re-install with a matching content hash does not copy again
  (ADR-AUTO-BUNDLE#6).
- The build kinds say only where the code root lives, and every kind loads through the same importer (ADR-DSGN-RUNMODE#7).

## Where the code and the ADR differ

ADR-DSGN-RUNMODE#7 names a fourth kind, a cached build kept outside the repository and reused per commit, and says the kind is derived from
the code root. No code makes a cached build, and the run-mode function answers only source or build, never the kind.

## See also

- [Platform bundle](../../adr/automation/platform-bundle.md) — the decision this article explains.
- [Run modes](../../adr/design/run-modes.md) — the build kinds.
- The other lenses on the same bundle: [architecture](every-code-root-is-a-copy.md), [implementation](build-verify-then-copy-the-folder.md),
  [operations](build-then-place-with-one-command.md) and [governance](what-gates-each-bundle-stage.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
