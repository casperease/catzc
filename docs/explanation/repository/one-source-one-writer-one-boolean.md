# Who owns each managed root file

```text
Every managed root file has one source of truth, one writer, and one boolean that decides git membership.

1  source of truth     the one authored file or generator function an entry names
2  registry            the one list of managed root files and how each one lands
3  single writer       the one function that reproduces every opted-in target on every import
4  gitignored target   a derived file that git ignores: 22 of the 28 entries
5  tracked target      a file git or the bootstrap reads before the importer runs: 6 of 28

Supports ADR-REPO-ROOTCFG-FULLYMANAGED, ADR-REPO-ROOTCFG-REGISTRY, ADR-REPO-ROOTCFG-COMMITTEDFLAG,
ADR-REPO-README-READMEIDEMPOTENT and ADR-REPO-ROOTCFG-HEADEDCOPY (meta lens).
```

The repository root carries configuration files for git, editors and quality-gate tools. Cats does not keep them by hand: each one that is
opted in is reproduced as a headed file from one source of truth inside `pwsh/`, by one writer, on every import. Whether the reproduced file
is gitignored or stays tracked is one boolean per entry, not a second system.

![Who owns each managed root file][diagram]

[diagram]: .assets/one-source-one-writer-one-boolean.drawio.png

## Walkthrough

1. **Source of truth.** Every entry names exactly one: an authored template that is copied out under a generated-file head, or a generator
   function whose rendered output is the whole file. Corrections go to the source. A reproduced file is a rendering and is never
   hand-edited; the template stays the pure authored file (ADR-REPO-ROOTCFG-HEADEDCOPY).
2. **Registry.** One list declares which root files are managed and how each one lands. Opt-out is the default: a root file with no entry,
   or an entry that is not opted in, stays hand-authored and committed. Today every one of the 28 entries is opted in.
3. **Single writer.** `Build-RootConfig` reads the registry, keeps the opted-in entries, and reproduces each target from its source through
   `Write-FileIfChanged`. The importer tail calls it on every load, and it is idempotent: a clean tree is a fast no-op.
4. **Gitignored target.** By default a managed target is a derived artifact that git ignores, materialised on import like the generated
   module manifests. 22 of the 28 entries land this way.
5. **Tracked target.** Some root files are read before the importer can have produced them: the import entry points, the files git reads at
   checkout, and the inputs of the bootstrap. Those 6 stay tracked, with the automation still owning their content, so a source change
   surfaces as a reviewable diff.

## Why it holds

- An opted-in root file is fully managed: materialised from exactly one in-repo source of truth, a `source` file or a `generator` function,
  and never corrected in place (ADR-REPO-ROOTCFG-FULLYMANAGED).
- A `source` entry is a headed copy of its template, never a link to it, so the template stays the pure authored file
  (ADR-REPO-ROOTCFG-HEADEDCOPY).
- The registry is one file, validated by one type and materialised by one writer; opt-out is the default and `optIn: true` is the explicit
  takeover switch (ADR-REPO-ROOTCFG-REGISTRY).
- Per entry, `committed` decides git membership and nothing else: false is a gitignored artifact, true is a tracked file the bootstrap needs
  before the importer runs (ADR-REPO-ROOTCFG-COMMITTEDFLAG).
- Generation is idempotent and runs on every import, so a target can never go stale between loads (ADR-REPO-README-READMEIDEMPOTENT).

## See also

- [Generated root configs](../../drs/repository/generated-root-configs.md) — the decision this article explains.
- The other lenses on the same mechanism: [architecture](what-materialises-the-root-config.md),
  [implementation](how-an-opted-in-root-file-is-placed.md), [operations](how-the-import-keeps-root-files-current.md) and
  [governance](what-checks-the-root-config-registry.md).
- [The repository explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
