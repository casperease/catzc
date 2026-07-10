# ADR: Effective in enterprise environments

## Rules: ADR-AUTO-ENTERP

### Rule ADR-AUTO-ENTERP:3

Never call the PowerShell Gallery at runtime. `Install-Module` and `Find-Module` need network and gallery availability; all module
dependencies are vendored.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-ENTERP:4

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

- **Locked-down, network-polluted module paths.** Group Policy or login scripts may add network shares to the module search path, which the
  engine then scans on every lookup. How the module path is kept local and deterministic is the language layer,
  [module-path-hygiene](powershell/module-path-hygiene.md) (`ADR-AUTO-MODPATH`).

- **Proxy and firewall.** Gallery access (`Install-Module`, `Find-Module`) may be blocked or require proxy configuration. Operations that
  need the network at runtime are unreliable.

- **Real-time antivirus.** Endpoint protection (e.g. Defender) scans each file on first open. The importer opens ~200 `.ps1` function files,
  so the dominant cost of a _cold_ import — the first one after a fresh checkout, a file change, or a reboot — is this per-file scan. Once
  the scan cache is warm, steady-state imports are sub-second; the scan does not recur until files change again. See "antivirus file
  scanning" below.

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

We vendor every dependency and assume nothing about the machine: no gallery or network access at runtime, no elevation, no dependence on the
user profile. The PowerShell module-path mechanics that make the vendored copies win — and the one-time fix for a network user path — are
the language layer, [module-path-hygiene](powershell/module-path-hygiene.md) (`ADR-AUTO-MODPATH`).

### How this is enforced

- **Vendoring** — all module dependencies are checked into `.vendor/`, eliminating gallery access at runtime
  ([vendor-toolset-dependencies](powershell/vendor-toolset-dependencies.md)).
- **`Install-VendorModule`** — the only supported way to add modules, runs once at authoring time, not at runtime.
- **The module-path mechanics** — the vendored-copy-wins loader surgery and the network-share warning live in
  [module-path-hygiene](powershell/module-path-hygiene.md).

## Consequences

- The automation works behind firewalls and proxies with no gallery access, and provisions fully without local admin.
- Machine-specific slowness has environmental fixes, not code workarounds: the module-path mechanics live in
  [module-path-hygiene](powershell/module-path-hygiene.md), and the cold-import antivirus cost is mitigated by an exclusion, not a code
  change.
