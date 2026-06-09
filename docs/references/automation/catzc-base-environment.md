# Catzc.Base.Environment

The host environment and PATH module. It owns reading and writing the **persistent PATH** — the durable, system-level value that survives a
shell restart — adding and removing individual entries, and re-syncing the live session after a change. It is a member of the `Base` group
and depends on [Catzc.Base.Asserts](catzc-base-asserts.md) for input guards. What it deliberately does not own is CI/pipeline detection
(that lives in [Catzc.Base.Repository](catzc-base-repository.md)) or general environment-variable management beyond PATH.

## Domains

| Domain   | Area    | Name                                                                   |
| -------- | ------- | ---------------------------------------------------------------------- |
| domain:1 | path    | [Persistent PATH management](#domain1--persistent-path-management)     |
| domain:2 | session | [Session PATH synchronization](#domain2--session-path-synchronization) |

### domain:1 — Persistent PATH management

Reading and writing the durable PATH — the value kept in the operating-system registry on Windows and in the shell profile on Unix, not the
in-session copy. This domain reads the current persistent PATH, replaces it wholesale, and adds or removes individual entries by name.
Changes here survive shell restarts because they target the system store directly; they do not appear in the running session until the
session PATH is re-synced (see [domain:2](#domain2--session-path-synchronization)). See
[environment-variables](../../adr/automation/environment-variables.md) for the conventions that govern how the platform reads and writes OS
environment state.

### domain:2 — Session PATH synchronization

Making a persistent PATH change visible in the running shell without a restart. After `Add-PermanentPath` or `Remove-PermanentPath` updates
the durable store, `Sync-SessionPath` re-reads the system PATH and installs it into `$env:PATH` so the current session sees the change
immediately. This domain is deliberately thin — it is the "make it live now" step, nothing more.

## What the module does

The module rests on a two-layer view of PATH: the durable store that the operating system holds (domain 1), and the live copy the current
shell inherits (domain 2). Every function in domain 1 talks directly to the persistent store — `Get-EnvironmentPath` and
`Set-EnvironmentPath` read and replace it in full, while `Add-PermanentPath` and `Remove-PermanentPath` do targeted edits. None of them
touch `$env:PATH`, which means they are safe to call in any context and their effect is always reproducible. `Sync-SessionPath` is the
deliberate bridge: it exists precisely because the two layers are separate, and it must be called explicitly when a caller needs the change
to take effect now.

The module ships one asset alongside its public functions: `assets/Set-LocalPSModulePath.ps1`. This is a one-time helper that writes a local
PSModulePath entry into the user-scope `powershell.config.json`, preventing PowerShell from scanning a slow network share on every import.
It is not a public function — it is an advisory script a developer runs once when setting up a machine on a domain network. The governing
rationale is in [effective-in-enterprises](../../adr/automation/effective-in-enterprises.md).

The module has no configuration files and no private helpers. All input validation is delegated to
[Catzc.Base.Asserts](catzc-base-asserts.md), keeping each function's body focused on the PATH operation itself.

## Division

The module's public functions, sorted into the domains above.

| Domain                                  | Function               |
| --------------------------------------- | ---------------------- |
| domain:1 — Persistent PATH management   | `Get-EnvironmentPath`  |
|                                         | `Set-EnvironmentPath`  |
|                                         | `Add-PermanentPath`    |
|                                         | `Remove-PermanentPath` |
| domain:2 — Session PATH synchronization | `Sync-SessionPath`     |
