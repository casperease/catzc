---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files.md
    kind: reference
    language: markdown
    track: docs
    body_sha: c7171ef4d460
    adrs:
      - ADR-AUTO-TRACKED#9
    links:
      - docs/adr/automation/open-closed-architecture.md
      - docs/adr/automation/tracked-files-from-the-index.md
      - docs/references/automation/catzc-base-git.md
---

# Catzc.Base.Files

The filesystem and source-control module. It owns the shared write primitives every generated-artifact builder shares —
`Write-FileIfChanged` for idempotent canonical content, `Set-FileLink` for link targets — plus an efficient directory-tree copy, file-lock
detection, and the git working-tree facts (branch, commit, committing) that higher-level modules build on without reinventing. It is a
member of the `Base` group (see [open-closed-architecture](../../adr/automation/open-closed-architecture.md)) and depends on
Catzc.Base.Execution (for `git` invocations) and Catzc.Base.Asserts (for the Assert/Test convention the lock-check pairs follow).

## Responsibilities

| Responsibility   | Area       | Name                                                             |
| ---------------- | ---------- | ---------------------------------------------------------------- |
| responsibility:1 | filesystem | [Filesystem operations](#responsibility1--filesystem-operations) |
| responsibility:2 | git        | [Source-control facts](#responsibility2--source-control-facts)   |

### responsibility:1 — Filesystem operations

Materialising and observing files on disk. The two write primitives are the write tail every generated-artifact builder shares
(Build-RootConfig, Build-Readme, Build-GitKeep, …): `Write-FileIfChanged` canonicalises content, compares EOL-insensitively, and writes only
on a real change — delete-then-write, so a changed write can never tunnel through a linked target into its source; `Set-FileLink`
materialises a file as a filesystem link to a source of truth (a relative symbolic link where permitted, a hard link on privilege-less
Windows, a throw — never a content copy). The directory copy uses the .NET APIs directly for efficiency — no shelling out, no intermediate
listings. The lock check reports whether a file is held open by another process; the Assert/Test pairs make both the throwing and querying
forms available, so callers with different error-handling needs can choose without duplicating the detection logic. The holder lookup goes
one step further and names _which_ processes hold the file (id, executable, start time, command line, parent process), through the Windows
Restart Manager — no admin rights needed, and it sees a loaded DLL as well as an open handle; on Linux/macOS, where locks are advisory, it
reports none.

### responsibility:2 — Source-control facts

Reading the working tree's current git branch and commit, and committing a scoped path set. The branch and commit are read in-process from
git's ref files through the `GitRefs` reader in [Catzc.Base.Git](catzc-base-git.md), so no process starts
([tracked-files-from-the-index](../../adr/automation/tracked-files-from-the-index.md), ADR-AUTO-TRACKED#9). Committing writes, so it calls
`Invoke-Executable` (from Catzc.Base.Execution) to run `git` with logged, exit-code-managed invocations, the same discipline every external
command in the platform follows. Branch and commit are intentionally separate getters: they serve different purposes for callers (log
context, cache keys, CI identifiers) and neither implies the other.

## What the module does

This module delivers two small, independent slices of infrastructure. Filesystem operations (responsibility 1) concern the state of files on
disk: how a generated artifact is written or linked idempotently, can a file be opened, and how do you copy a tree cleanly? Source-control
facts (responsibility 2) concern the state of the working tree: what branch is active, what commit is current? Neither responsibility
reaches into the other, and neither has any configuration to own.

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
|                                          | `Set-FileLink`           |
|                                          | `Copy-Directory`         |
|                                          | `Assert-FileIsLocked`    |
|                                          | `Test-FileIsLocked`      |
|                                          | `Assert-FileIsNotLocked` |
|                                          | `Test-FileIsNotLocked`   |
|                                          | `Get-FileLockingProcess` |
| responsibility:2 — Source-control facts  | `Get-GitCurrentBranch`   |
|                                          | `Get-GitCurrentCommit`   |
|                                          | `Invoke-GitCommit`       |
