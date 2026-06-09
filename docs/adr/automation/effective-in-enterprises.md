# ADR: Effective in enterprise environments

## Rules: ADR-ENTERP

### Rule ADR-ENTERP:1

Never add network paths to `$env:PSModulePath`. If a module is needed, vendor it; if it cannot be vendored (Az modules), the environment
must install it locally.

- [The specific problem: PSModulePath](#the-specific-problem-psmodulepath)
- [What the importer does](#what-the-importer-does)

### Rule ADR-ENTERP:2

Don't depend on the user profile at runtime. No function reads or writes `$HOME\Documents\PowerShell\` during import or a normal run; the
one sanctioned exception is the opt-in `Set-LocalPSModulePath.ps1` helper the user runs by hand.

- [The one-time fix for network user paths](#the-one-time-fix-for-network-user-paths)

### Rule ADR-ENTERP:3

Never call the PowerShell Gallery at runtime. `Install-Module` and `Find-Module` need network and gallery availability; all module
dependencies are vendored.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-ENTERP:4

Assume no local admin. Tool installers use `winget` (per-user), `brew`, or `apt-get`, and functions must not require elevation unless
explicitly documented.

- [Context](#context)

## Context

Enterprise environments impose constraints that developer-oriented tooling rarely accounts for:

- **Home folders on network storage.** Central IT redirects `$HOME` or the Documents folder to DFS, mapped network drives, or OneDrive for
  Business (Known Folder Move). This means any operation that touches `$HOME\Documents\PowerShell\` — module discovery, profile loading, tab
  completion — traverses the network. On a bad day this adds seconds per operation. On a DFS failover day it hangs indefinitely.

- **No local admin.** Developers cannot install software, modify system paths, or change Group Policy settings. The automation must work
  within the permissions they have.

- **No container runtime.** Docker Desktop requires a license and local admin. Many enterprise machines do not have it. The automation
  cannot depend on containers (see [controlling-systemwide-deps](controlling-systemwide-deps.md)).

- **Locked-down PSModulePath.** Group Policy or login scripts may add network paths to `$env:PSModulePath`. PowerShell scans every path on
  module auto-load, tab completion, and `Get-Module -ListAvailable`. Network paths in this list are the primary cause of "PowerShell is
  slow" in enterprises.

- **Proxy and firewall.** Gallery access (`Install-Module`, `Find-Module`) may be blocked or require proxy configuration. Operations that
  need the network at runtime are unreliable.

- **Real-time antivirus.** Endpoint protection (e.g. Defender) scans each file on first open. The importer opens ~200 `.ps1` function files,
  so the dominant cost of a _cold_ import — the first one after a fresh checkout, a file change, or a reboot — is this per-file scan. Once
  the scan cache is warm, steady-state imports are sub-second; the scan does not recur until files change again. See "antivirus file
  scanning" below.

### The specific problem: PSModulePath

PowerShell's default `$env:PSModulePath` includes:

```text
$HOME\Documents\PowerShell\Modules     ← user profile (NETWORK)
C:\Program Files\PowerShell\Modules    ← system-wide PS 7 (local)
$PSHOME\Modules                        ← pwsh built-in (local)
```

The first entry is the killer. Every time PowerShell auto-loads a module, resolves a command, or offers tab completion, it scans this path.
When it points to a network share, each scan is a network round-trip. With DFS, it can be multiple round-trips through namespace resolution.

We vendor all dependencies. The user profile module path is never needed.

### The other problem: antivirus file scanning

One-function-per-file (see [use-ps1-not-psm1](powershell/use-ps1-not-psm1.md)) means the importer opens ~200 `.ps1` files. Real-time
antivirus scans each on **first** open and caches it clean, so the _first_ import in a fresh checkout/session is slow and every later one is
fast.

On an enterprise machine, `importer.ps1 -DiagnoseLoadTime` shows a sharp cold/warm split (two back-to-back runs):

```text
cold (1st run):  ~12.5s   raw-read (pure file open) ≈ 8.8s; parse ≈ 3.6s
warm (2nd run):   ~0.2s   every read 0–10ms
```

The `-DiagnoseLoadTime` breakdown splits each module into `manifest` (enumeration), `raw-read` (a probe that opens every `.ps1` raw, before
`Import-Module`), and `import` (parse). A large `raw-read` on the cold run is the antivirus-on-open signature — re-run it to re-confirm.
Enumeration is native `.NET` and ~1–7ms, so it is never the cause; the file opens are.

**Mitigation is environmental, not code.** No code avoids opening the files, and merging them into one file to cut the open count is the
rejected generated-module approach in [use-ps1-not-psm1](powershell/use-ps1-not-psm1.md). The fix is an antivirus exclusion for the
repository working copy and `automation/.vendor/`. (The C# in the `types/` folders ship a committed, hash-keyed prebuilt DLL in
`automation/.compiled/`, so a fresh checkout and CI load it without invoking Roslyn — only a developer who edits a type source pays the
`~0.5s` compile, once — but that is secondary to the per-file scan.)

## Decision

We vendor every dependency and make the vendored copies win, rather than reshaping the whole environment. The vendor loader surgically
strips the module paths that would let a system- or profile-installed copy override what we ship, and the network-path slowdown is addressed
separately by an optional one-time helper that points the user module path at local disk.

Two distinct mechanisms, neither of which rebuilds `$env:PSModulePath` from scratch:

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
- **Vendoring** — all module dependencies are checked into `.vendor/`, eliminating gallery access at runtime.
- **`Install-VendorModule`** — the only supported way to add modules, runs once at authoring time, not at runtime.

## Consequences

- The vendored copy of every dependency wins, regardless of what is installed system-wide or in the user profile.
- Once `Set-LocalPSModulePath.ps1` has been run, the user module path is local, so module lookups and tab completion do not scan a network
  share — no DFS resolution, no OneDrive sync delays.
- The automation works behind firewalls and proxies with no gallery access.
- A non-vendored personal module that shares a name with a vendored one is shadowed by the vendored copy in sessions that dot-source the
  importer. This is intentional — the automation session uses what it ships.
- System-installed modules that do not collide with a vendored module remain available; only the colliding paths are stripped.
