# Partition integrity runs only in unit tests

```text
Partition integrity runs only in unit tests, and the per-aspect sha lock has no mechanism.

1  pwsh/<Module>/                the module folder every stage starts from
2  Test-SourceConventions        quality gate: one function per file, one definition per name
3  Test-FolderConventions        quality gate: only conventional module subfolders
4  Assert-Unique...FunctionName  import guard: unique exported names, fails fast
5  New-DynamicManifest           no gate: the import regenerates every manifest
6  VariantsConfig                config check: ** is last, and only last
7  AspectPartition.Validate      ADR-only on the real tree: runs in unit tests only
8  Aspect sha lock               ADR-only: nothing writes one

Supports DDR-ASPECT-ASPECTSAREDERIVED, DDR-ASPECT-TRACKPICKSCATCHALL, DDR-ASPECT-ASPECTISAGLOBSET, DDR-ASPECT-PARTITIONISCHECKED, ADR-PWSH-ONEFUNC-ONEFUNCTIONPERFILE, ADR-PWSH-MANIFEST-ONEDEFINITIONPERNAME, ADR-PWSH-MANIFEST-GENERATEDMANIFESTS, ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED, ADR-REPO-FOLDERS-FIXEDMODULEFOLDERS and FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT (governance lens).
```

Every stage of a cats module's folder layout is ruled by a decision record, and most of those rules have a gate: a quality gate, a guard at
import, or a check when the config loads. Two do not. The partition check of DDR-ASPECT-PARTITIONISCHECKED runs only in unit tests, on
fixtures, and the per-aspect sha lock of DDR-ASPECT-ASPECTISAGLOBSET has no mechanism at all. Knowing which rules a gate holds, and which
only the DDR states, tells a reviewer where a mistake would slip through.

![Partition integrity runs only in unit tests](.assets/partition-integrity-runs-only-in-unit-tests.drawio.png)

## Walkthrough

1. **pwsh/&lt;Module&gt;/.** The module folder every stage starts from. Two quality gates read it, and the import guard reads it before
   anything loads.
2. **Test-SourceConventions.** A quality gate. It checks that each source file holds exactly one top-level function named for the file
   (ADR-PWSH-ONEFUNC-ONEFUNCTIONPERFILE), and that every function name, public or private, is defined in exactly one file, the integrity
   half of ADR-PWSH-MANIFEST-ONEDEFINITIONPERNAME.
3. **Test-FolderConventions.** A quality gate. It checks that every module subfolder is a conventional one: `private`, `tests`, `assets`,
   `types` or `configs` (ADR-REPO-FOLDERS-FIXEDMODULEFOLDERS). `assets/` is conventional but not in the live convention, so module assets
   fall to `tests`; the DDR's Related section calls the bundle payload deliberately broader than `live`.
4. **Assert-UniqueModuleFunctionName.** The import guard, shown shortened as `Assert-Unique…FunctionName`. `Import-AllModules` calls it
   before any module or type loads, and it fails fast on a duplicate exported name or one that shadows an imported command
   (ADR-PWSH-MANIFEST-ONEDEFINITIONPERNAME).
5. **New-DynamicManifest.** No gate: the import itself regenerates every manifest, and the file is gitignored
   (ADR-PWSH-MANIFEST-GENERATEDMANIFESTS, ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED).
6. **VariantsConfig.** The config type checks the aspect order when the config loads: the last aspect is the bare `**` catch-all and no
   earlier aspect uses it, so `live` stays closed (DDR-ASPECT-ASPECTSAREDERIVED, DDR-ASPECT-TRACKPICKSCATCHALL).
7. **AspectPartition.Validate.** The disjoint and exhaustive check over `git ls-files` (DDR-ASPECT-PARTITIONISCHECKED). The code exists, but
   its only callers are unit tests on fixture files, so on the real tree it is ADR-only.
8. **Aspect sha lock.** One immutable lock per aspect, so a module is two independently versioned artifacts (DDR-ASPECT-ASPECTISAGLOBSET),
   with the mechanism placed in FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT. Nothing writes such a lock.

## Why it holds

- Each `.ps1` file holds exactly one function, and its name matches the file (ADR-PWSH-ONEFUNC-ONEFUNCTIONPERFILE).
- Every function name resolves to exactly one definition, and the import fails fast before anything loads when two would collide
  (ADR-PWSH-MANIFEST-ONEDEFINITIONPERNAME).
- Manifests are generated from the filesystem on every import and never committed (ADR-PWSH-MANIFEST-GENERATEDMANIFESTS,
  ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED).
- Module-internal folder names are fixed (ADR-REPO-FOLDERS-FIXEDMODULEFOLDERS).
- Aspects are derived by ordered first match, the last one is the `**` remainder, and in the code track that remainder is `tests`
  (DDR-ASPECT-ASPECTSAREDERIVED, DDR-ASPECT-TRACKPICKSCATCHALL).
- Each aspect is an immutable, independently versioned lock (DDR-ASPECT-ASPECTISAGLOBSET), and a file claimed by two aspects, or by none,
  fails the integrity check (DDR-ASPECT-PARTITIONISCHECKED).

## Where the code and the decision record differ

- DDR-ASPECT-PARTITIONISCHECKED says a broken partition fails `AspectPartition.Validate`, and the type's reference page (`Aspect.cs.md`)
  says it re-checks "for the integrity gate", but no gate runs it on the real tree.
- DDR-ASPECT-ASPECTISAGLOBSET cites FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT for an immutable sha lock with marker `<unit>-<aspect>.yml`; that
  rule computes change from git, never from a committed hash, and no marker exists.
- ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED names `New-DynamicManifest` as the step that deletes a manifest when no `.ps1` is left; the code
  deletes it in `Import-AllModules`.
- ADR-REPO-FOLDERS-UNKNOWNFOLDERSIGNORED says unknown folders are ignored, not errors; `Test-FolderConventions` reports every
  non-conventional module subfolder as an issue, while the loader does skip them.

## See also

- [Module aspects](../../drs/design/module-aspects.md) — the decision this article explains. Also
  [dynamic module manifests](../../drs/automation/pwsh/dynamic-module-manifests.md),
  [one function per file](../../drs/automation/pwsh/one-function-per-file.md),
  [conventional folders](../../drs/repository/conventional-folders.md) and [durable sha globs](../../drs/flow/durable-sha-globs.md).
- The other lenses on the same layout: [meta](every-file-in-exactly-one-aspect.md), [architecture](one-folder-two-independent-readers.md),
  [implementation](manifest-and-aspects-from-one-folder.md) and [operations](drop-a-file-the-import-exports-it.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
