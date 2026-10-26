# pwsh/Base.Docs/Build-GitKeep.ps1

The writer that keeps every `.gitkeep` of the repository a managed copy of one generic asset. It walks the tree, skips `.git` and the
vendored modules, and rewrites a file only when it drifted. Its tests are in [Build-GitKeep.Tests.ps1](tests/build-git-keep.md).

## help

### synopsis

Reproduces every .gitkeep from the one generic authored source — the writer behind the ".gitkeep files are generated, README-backed"
contract.

### description

The folder is the registration: every .gitkeep in the repository (found by a filesystem walk that skips `.git` and the vendored modules) is
a managed copy of this module's assets/gitkeep (located through Get-CatzcModuleRoot, so it resolves inside the loaded module in both run
modes) — a generic text saying the file keeps its folder tracked and that the folder's story lives in its README.md. That pointer is honest
because an integrity test requires every .gitkeep folder to be a readme-mapped target (a docs/references article Build-Readme copies in), so
adding a .gitkeep anywhere demands its reference article — the gap finder for the reference docs.

Idempotent and fast by construction, so the importer runs it on every load beside Build-Readme: writes go through Write-FileIfChanged
(canonical output, EOL-insensitive compare, write only on drift). .gitkeep files are committed — tracking the folder is their whole job — so
a source change lands as a reviewable diff across every location. See [ADR-REPO-README](../../../drs/repository/generated-readmes.md).

It rests on [ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths).

### parameter `DryRun`

Report what would change without writing any file. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Silent`

The per-file status lines are verbose-level — -Silent suppresses them entirely, even under -Verbose (used by the importer tail).

### parameter `PassThru`

Return one result object per .gitkeep ({ Path, Changed, DryRun }) instead of the paths.

### outputs

`[string[]]` The repo-relative paths of the managed .gitkeep files (with -PassThru, one result object per file instead).

### example 1

```powershell
Build-GitKeep
Reproduces every .gitkeep from the authored source.
```

### example 2

```powershell
Build-GitKeep -DryRun -PassThru
Reports which .gitkeep files are stale without writing them.
```
