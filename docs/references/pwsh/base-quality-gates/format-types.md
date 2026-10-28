# pwsh/Base.QualityGates/Format-Types.ps1

The formatter for the C# type sources: it keeps each file's file-scoped namespace the one its module folder gives, so a type file never
carries a hand-written namespace.

## help

### synopsis

Maintains the file-scoped namespace on each C# type source, derived from its module folder.

### description

Every catzc C# type lives at `pwsh/<Module>/types/<Type>.cs` and belongs to namespace `<Module>` (record native-csharp-types). The namespace
is NOT hand-authored: this formatter writes/repairs the `namespace <Module>;` line from the file's folder, so the folder stays the single
source of truth and a move between modules is a safe refactor — re-running Format-Types rewrites the line to the new folder, and
Test-Formatting (its -DryRun) fails CI on any drift. The declared namespace is what lets the editor's C# toolchain compile and analyze these
files (no CA1050), so the rule is visible in-editor (everything-as-code).

For each `types/*.cs`: the line is inserted after the leading comment/using block (before the first type or attribute) when absent,
corrected when it names the wrong module, and left untouched when already correct. Files are written back as UTF-8 without a BOM with LF
line endings (repo convention). Logic is never changed — only the namespace line. A block-scoped `namespace X { … }` is the one shape it
cannot fix: it is left untouched and reported in BlockScopedFiles (Test-Formatting turns each into an issue).

A source-tree tool: it rewrites the repository's type sources, so it throws in build mode (Assert-SourceTree).

### parameter `Path`

One or more files or directories to process. Defaults to every `pwsh/<Module>/types/*.cs` file.

### parameter `DryRun`

Report which files would change without writing them (the returned list is the same either way).

### parameter `PassThru`

Return a result object ({ ChangedCount, ChangedFiles, BlockScopedFiles, DryRun }) instead of only logging.

### outputs

`[string[]]` The paths of the files that changed (or, under -DryRun, would change).

### example 1

```powershell
Format-Types
```

### example 2

```powershell
Format-Types -DryRun
```

## Scope

The `.cs` sources exist only in the source tree, since a build ships the compiled assembly and not the sources. A types file sits under
`<module>/types`, so a folder as wide as `pwsh/` is three levels up from the files, which is the walk depth.

## Namespace

The namespace is the full name of the module whose `types/` folder holds the file. A block-scoped `namespace X { â€¦ }` is not a shape this
repository authors, and rewriting it is no one-line fix, so the command reports it for a hand edit.

## Speed

The command uses `[System.IO]` enumeration on this path, because each cmdlet call here costs about 20 ms
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
