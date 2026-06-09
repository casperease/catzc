# Catzc.Base.Files

The filesystem and source-control module. It owns an efficient directory-tree copy, file-lock detection, and reading the current git branch
and commit — the low-level observations that higher-level modules build on without reinventing. It is a member of the `Base` group (see
[open-closed-architecture](../../adr/automation/open-closed-architecture.md)) and depends on Catzc.Base.Execution (for `git` invocations)
and Catzc.Base.Asserts (for the Assert/Test convention the lock-check pairs follow).

## Domains

| Domain   | Area       | Name                                                     |
| -------- | ---------- | -------------------------------------------------------- |
| domain:1 | filesystem | [Filesystem operations](#domain1--filesystem-operations) |
| domain:2 | git        | [Source-control facts](#domain2--source-control-facts)   |

### domain:1 — Filesystem operations

Copying a directory tree and checking whether a file handle is locked. The copy uses the .NET APIs directly for efficiency — no shelling
out, no intermediate listings. The lock check reports whether a file is held open by another process; the Assert/Test pairs make both the
throwing and querying forms available, so callers with different error-handling needs can choose without duplicating the detection logic.

### domain:2 — Source-control facts

Reading the working tree's current git branch and commit. Both functions call `Invoke-Executable` (from Catzc.Base.Execution) to run `git`
with logged, exit-code-managed invocations — the same discipline every external command in the platform follows. Branch and commit are
intentionally separate getters: they serve different purposes for callers (log context, cache keys, CI identifiers) and neither implies the
other.

## What the module does

This module delivers two small, independent slices of infrastructure. Filesystem operations (domain 1) concern the state of files on disk:
can a file be opened, and how do you copy a tree cleanly? Source-control facts (domain 2) concern the state of the working tree: what branch
is active, what commit is current? Neither domain reaches into the other, and neither has any configuration to own.

The Assert/Test pairs in domain 1 follow the platform convention: the `Assert-` form throws on a violated condition; the `Test-` form
returns a Boolean. Both call the same underlying detection, so they can never disagree — a guarantee the pattern provides across the whole
`Base` group.

The git functions illustrate why this module depends on Catzc.Base.Execution rather than invoking `git` directly. `Invoke-Executable`
handles the command log, the exit-code boundary, and the dry-run short-circuit; `Get-GitCurrentBranch` and `Get-GitCurrentCommit` inherit
all of that for free, and no git call in the module bypasses the managed entry point.

## Division

The module's public functions, sorted into the domains above.

| Domain                           | Function                 |
| -------------------------------- | ------------------------ |
| domain:1 — Filesystem operations | `Copy-Directory`         |
|                                  | `Assert-FileIsLocked`    |
|                                  | `Test-FileIsLocked`      |
|                                  | `Assert-FileIsNotLocked` |
|                                  | `Test-FileIsNotLocked`   |
| domain:2 — Source-control facts  | `Get-GitCurrentBranch`   |
|                                  | `Get-GitCurrentCommit`   |
