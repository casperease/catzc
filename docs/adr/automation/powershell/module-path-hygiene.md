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
- [Why the user-scope config override, and not the alternatives](#why-the-user-scope-config-override-and-not-the-alternatives)

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

### Why the user-scope config override, and not the alternatives

The fix targets the user-scope `powershell.config.json` deliberately, because every other way to keep the network path out of
`$env:PSModulePath` is worse:

- **Stripping the UNC entry at runtime** does not hold. PowerShell reconstructs `$env:PSModulePath` during certain operations — the
  Windows-compatibility layer starts a background Windows PowerShell 5.1 process whose path includes the DFS-based Documents path, and PS7
  inherits those entries back when that process completes; module auto-loading can trigger the same reconstruction. The network path
  reappears unpredictably.
- **A symlink** from `Documents\PowerShell` to a local directory works only after migrating any existing profile, module cache, and history
  out of the network location first (the link target must not already exist), and a profile loaded through a symlink from a DFS origin is
  still treated as remote by `RemoteSigned`, forcing a `Bypass` execution policy. That migration is too error-prone to automate safely
  across every user.
- **An AllUsers config** (`$PSHOME\powershell.config.json` with a `PSModulePath` key) sets the AllUsers module path, not the CurrentUser
  one, so the network user path remains — and it overrides `$PSHOME\Modules`, hiding the built-in core modules.
- **A user-scoped `PSModulePath` registry value** (`HKCU:\Environment`) is read by PS7 as a full user override, so it stops appending
  `$PSHOME\Modules` and the core modules become undiscoverable.
- **Suppressing auto-loading** (`$PSModuleAutoLoadingPreference = 'None'`) hides the scanning symptom but breaks
  `Get-Module -ListAvailable`, command discovery, and anything that relies on module auto-loading.

The user-scope `powershell.config.json` override avoids all of these: it sets only the CurrentUser module path, leaves `$PSHOME\Modules`
intact so the core modules stay discoverable, is read once at startup rather than reconstructed mid-session, and needs no admin.

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

## Dora explains:

DORA's research on flexible infrastructure emphasizes deterministic dependencies—and network module paths destroy performance in enterprise
environments. Vendoring PowerShell modules and keeping the module path local by default eliminates network round-trips, makes module loading
predictable, and enables fast automation everywhere.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — running reliably in enterprise environments without
  network delays.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — deterministic, local dependencies enable consistent
  automation across machines.
- [Version control](https://dora.dev/capabilities/version-control/) — vendored modules are reproducible and tracked without gallery access.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
