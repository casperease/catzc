# ADR: Module-path hygiene — the PowerShell layer over effective-in-enterprises

## Rules: ADR-MODPATH

### Rule ADR-MODPATH:1

Never add network paths to `$env:PSModulePath`. If a module is needed, vendor it; if it cannot be vendored (Az modules), the environment
must install it locally.

- [The specific problem: PSModulePath](#the-specific-problem-psmodulepath)
- [What the importer does](#what-the-importer-does)

### Rule ADR-MODPATH:2

Don't depend on the user profile at runtime. No function reads or writes `$HOME\Documents\PowerShell\` during import or a normal run; the
one sanctioned exception is the opt-in `Set-LocalPSModulePath.ps1` helper the user runs by hand.

- [The one-time fix for network user paths](#the-one-time-fix-for-network-user-paths)

### Rule ADR-MODPATH:3

The vendored copy of every dependency wins by **surgical removal**, never a wholesale rebuild: `Import-VendorModules` unloads any
non-vendored copy, strips each vendored module's folders from `$env:PSModulePath`, and prepends the `.vendor/` root. The importer otherwise
leaves `$env:PSModulePath` alone and **warns** when it contains a network share, pointing at the one-time fix.

- [What the importer does](#what-the-importer-does)

## Context

[effective-in-enterprises](../effective-in-enterprises.md) (`ADR-ENTERP`) fixes the constraints: home folders on network storage, no local
admin, no gallery access at runtime. This ADR is the PowerShell layer under it — how the module path is kept fast, local, and deterministic
on such a machine.

### The specific problem: PSModulePath

PowerShell's default `$env:PSModulePath` includes:

```text
$HOME\Documents\PowerShell\Modules     ← user profile (NETWORK)
C:\Program Files\PowerShell\Modules    ← system-wide PS 7 (local)
$PSHOME\Modules                        ← pwsh built-in (local)
```

The first entry is the killer. Every time PowerShell auto-loads a module, resolves a command, or offers tab completion, it scans this path.
When it points to a network share, each scan is a network round-trip. With DFS, it can be multiple round-trips through namespace resolution.
Group Policy or login scripts may add further network paths — the primary cause of "PowerShell is slow" in enterprises.

We vendor all dependencies ([vendor-toolset-dependencies](vendor-toolset-dependencies.md)). The user profile module path is never needed.

## Decision

The vendored copies win through surgical `$env:PSModulePath` edits at import, and the network-user-path slowdown is addressed by an optional
one-time helper that points the user module path at local disk — the importer never rebuilds the whole variable.

### What the importer does

The vendor loader (`Import-VendorModules` in `automation/.internal/Catzc.Internal.Bootstrap.psm1`) makes the vendored copy of each
dependency win, by **surgical removal** — not a wholesale rebuild:

- For each vendored module, if a copy is already loaded from somewhere other than `.vendor/`, it is removed (`Remove-Module`) so the
  vendored version can take its place.
- Every entry in `$env:PSModulePath` that contains a folder for _that_ module is stripped, so auto-loading cannot resurrect the system
  version after the vendored one is imported:

  ```powershell
  $env:PSModulePath = ($env:PSModulePath -split $sep |
      Where-Object { -not [System.IO.Directory]::Exists((Join-Path $_ $dir.Name)) }) -join $sep
  ```

- The `.vendor/` root is then prepended to `$env:PSModulePath` so deferred (lazy) vendor modules can still auto-load.

The importer does **not** otherwise enumerate or delete the user profile path. What it does do is **warn** when `$env:PSModulePath` contains
a UNC/network share, and point the user at the one-time fix below (see `importer.ps1`).

### The one-time fix for network user paths

The slow-network-path problem is solved by `automation/Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1`, a one-time helper the user
runs themselves. It writes a user-scope `powershell.config.json` (under `Documents\PowerShell`, even when that is on DFS) that overrides the
CurrentUser module path to a local directory (`$env:LOCALAPPDATA\PowerShell\Modules`). PowerShell reads that single config file once at
startup — fast — instead of recursively scanning a network share on every lookup.

This helper _does_ touch the user profile (it writes the config file there and may suggest moving existing modules off DFS). That is the
point: it is the user opting in to a permanent local redirect, run once, not something the automation does on every import. No admin is
required and it is idempotent.

### How this is enforced

- **`Import-VendorModules`** (in `automation/.internal/Catzc.Internal.Bootstrap.psm1`) — strips each vendored module's folder from
  `$env:PSModulePath` and unloads any non-vendored copy before importing the vendored one, so the vendored version always wins.
- **`importer.ps1`** — warns when `$env:PSModulePath` contains a network share and points the user at `Set-LocalPSModulePath.ps1` to fix it
  permanently.
- **Vendoring** — all module dependencies are checked into `.vendor/`, eliminating gallery access at runtime
  ([vendor-toolset-dependencies](vendor-toolset-dependencies.md)).

## Consequences

- The vendored copy of every dependency wins, regardless of what is installed system-wide or in the user profile.
- Once `Set-LocalPSModulePath.ps1` has been run, the user module path is local, so module lookups and tab completion do not scan a network
  share — no DFS resolution, no OneDrive sync delays.
- A non-vendored personal module that shares a name with a vendored one is shadowed by the vendored copy in sessions that dot-source the
  importer. This is intentional — the automation session uses what it ships.
- System-installed modules that do not collide with a vendored module remain available; only the colliding paths are stripped.
