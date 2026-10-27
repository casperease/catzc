# Catzc.Base.Files

The filesystem and source-control module. It owns the shared write primitives every generated-artifact builder shares —
`Write-FileIfChanged` for idempotent canonical content — plus an efficient directory-tree copy, file-lock detection, and the git
working-tree facts (branch, commit, committing) that higher-level modules build on without reinventing. It is a member of the `Base` group
(see [open-closed-architecture](../../../drs/automation/open-closed-architecture.md)) and depends on Catzc.Base.Execution (for `git`
invocations) and Catzc.Base.Asserts (for the Assert/Test convention the lock-check pairs follow).

## Responsibilities

| Responsibility   | Area       | Name                                                             |
| ---------------- | ---------- | ---------------------------------------------------------------- |
| responsibility:1 | filesystem | [Filesystem operations](#responsibility1--filesystem-operations) |
| responsibility:2 | git        | [Source-control facts](#responsibility2--source-control-facts)   |

### responsibility:1 — Filesystem operations

Materialising and observing files on disk. The write primitive is the write tail every generated-artifact builder shares (Build-RootConfig,
Build-Readme, Build-GitKeep, …): `Write-FileIfChanged` canonicalises content, compares EOL-insensitively, and writes only on a real change —
delete-then-write, so a changed write can never tunnel through a link into the file it points at. The directory copy uses the .NET APIs
directly for efficiency — no shelling out, no intermediate listings. The lock check reports whether a file is held open by another process;
the Assert/Test pairs make both the throwing and querying forms available, so callers with different error-handling needs can choose without
duplicating the detection logic. The holder lookup goes one step further and names _which_ processes hold the file (id, executable, start
time, command line, parent process), through the Windows Restart Manager — no admin rights needed, and it sees a loaded DLL as well as an
open handle; on Linux/macOS, where locks are advisory, it reports none. An input stamp fingerprints a set of files by their paths and
content, the same on every checkout of the same inputs.

### responsibility:2 — Source-control facts

Reading the working tree's current git branch and commit, and committing a scoped path set. The branch and commit are read in-process from
git's ref files through the `GitRefs` reader in [Catzc.Base.Git](../base-git/index.md), so no process starts
([tracked-files-from-the-index](../../../drs/automation/tracked-files-from-the-index.md), ADR-AUTO-TRACKED-INPROCESSREFS). Committing
writes, so it calls `Invoke-Executable` (from Catzc.Base.Execution) to run `git` with logged, exit-code-managed invocations, the same
discipline every external command in the platform follows. Branch and commit are intentionally separate getters: they serve different
purposes for callers (log context, cache keys, CI identifiers) and neither implies the other. It answers which of a set of paths git tracks,
which differ from HEAD (and whether any does), and where one file stands, from unset to pushed, a state computed on demand and never written
into the file. Over the tracked files, it finds the callers of a name and renames a set of names as whole tokens, so a rename moves every
in-tree caller in one change.

## What the module does

This module delivers two small, independent slices of infrastructure. Filesystem operations (responsibility 1) concern the state of files on
disk: how a generated artifact is written idempotently, can a file be opened, and how do you copy a tree cleanly? Source-control facts
(responsibility 2) concern the state of the working tree: what branch is active, what commit is current? Neither responsibility reaches into
the other, and neither has any configuration to own.

The Assert/Test pairs in responsibility 1 follow the platform convention: the `Assert-` form throws on a violated condition; the `Test-`
form returns a Boolean. Both call the same underlying detection, so they can never disagree — a guarantee the pattern provides across the
whole `Base` group.

The git functions show the platform's split between reading and writing git. Reads of small git formats (refs, the index) go through the
in-process readers in Catzc.Base.Git. Writes go through `Invoke-Executable`, which handles the command log, the exit-code boundary, the time
limit and the dry-run short-circuit, so no git process in the module bypasses the managed entry point.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                           | Function                 |
| ---------------------------------------- | ------------------------ |
| responsibility:1 — Filesystem operations | `Write-FileIfChanged`    |
|                                          | `Copy-Directory`         |
|                                          | `Assert-FileIsLocked`    |
|                                          | `Test-FileIsLocked`      |
|                                          | `Assert-FileIsNotLocked` |
|                                          | `Test-FileIsNotLocked`   |
|                                          | `Get-FileLockingProcess` |
|                                          | `Get-InputStamp`         |
| responsibility:2 — Source-control facts  | `Get-GitCurrentBranch`   |
|                                          | `Get-GitCurrentCommit`   |
|                                          | `Get-GitTrackedPath`     |
|                                          | `Get-GitChangedPath`     |
|                                          | `Test-GitPathChanged`    |
|                                          | `Get-RepoStatus`         |
|                                          | `Get-CodeCaller`         |
|                                          | `Rename-CodeName`        |
|                                          | `Invoke-GitCommit`       |
