# Automation: Effective in enterprise environments

## Rules: ADR-AUTO-ENTERP

### Rule ADR-AUTO-ENTERP-NOLOCALADMIN

Assume no local admin. Tool installers use `winget` (per-user), `brew`, or `apt-get`, and functions must not require elevation unless
explicitly documented.

- [Context](#context)

## Context

Enterprise environments impose constraints that developer-oriented tooling rarely accounts for:

- **Home folders on network storage.** Central IT redirects the home folder or the Documents folder to DFS, mapped network drives, or
  OneDrive for Business (Known Folder Move). This means any operation that touches the user profile — module discovery, profile loading, tab
  completion — traverses the network. On a bad day this adds seconds per operation. On a DFS failover day it hangs indefinitely.

- **No local admin.** Developers cannot install software, modify system paths, or change Group Policy settings. The automation must work
  within the permissions they have.

- **No container runtime.** Docker Desktop requires a license and local admin. Many enterprise machines do not have it. The automation
  cannot depend on containers (see [controlling-systemwide-deps](controlling-systemwide-deps.md)).

- **Locked-down, network-polluted module paths.** Group Policy or login scripts may add network shares to the module search path, which the
  engine then scans on every lookup. How the module path is kept local and deterministic is the engine twin's to say.

- **Proxy and firewall.** Access to a package feed may be blocked or require proxy configuration. Operations that need the network at
  runtime are unreliable, so the dependencies are vendored ([controlling-module-dependencies](controlling-module-dependencies.md)) and no
  engine calls a package gallery at runtime.

- **Real-time antivirus.** Endpoint protection (e.g. Defender) scans each file on first open. The importer opens ~400 function files, so the
  dominant cost of a _cold_ import — the first one after a fresh checkout, a file change, or a reboot — is this per-file scan. Once the scan
  cache is warm, steady-state imports are sub-second; the scan does not recur until files change again. See "antivirus file scanning" below.

### Antivirus file scanning

`The other problem: antivirus file scanning`

One function per file means the importer opens ~400 function files. Real-time antivirus scans each on **first** open and caches it clean, so
the _first_ import in a fresh checkout/session is slow and every later one is fast.

On an enterprise machine, the importer's `-DiagnoseLoadTime` switch shows a sharp cold/warm split (two back-to-back runs):

```text
cold (1st run):  ~12.5s   raw-read (pure file open) ≈ 8.8s; parse ≈ 3.6s
warm (2nd run):   ~0.2s   every read 0–10ms
```

The `-DiagnoseLoadTime` breakdown splits each module into `manifest` (enumeration), `raw-read` (a probe that opens every function file raw,
before the module is imported), and `import` (parse). A large `raw-read` on the cold run is the antivirus-on-open signature — re-run it to
re-confirm. Enumeration is native `.NET` and ~1–7ms, so it is never the cause; the file opens are.

**Source and build answer it differently.** Source stays one function per file: that is the form a developer reads, reviews, and diffs, so a
devbox in source mode pays the cold scan, and its mitigation is environmental — an antivirus exclusion for the repository working copy and
`pwsh/.vendor/`. The **installed build** is merged per module ([platform-bundle](platform-bundle.md), [run-modes](../design/run-modes.md)):
`Build-Modules` writes each module's functions into one generated function file, so a machine that runs the installed `Catzc` opens one
function file per module instead of one per function. That is the code-level answer to the cold-import antivirus cost, and it needs no
exclusion. (The C# in the `types/` folders compile once per machine into a hash-keyed build in the per-user shadow root, and a source edit
pays the `~0.5s` compile once — but that is secondary to the per-file scan.)

## Decision

We vendor every dependency and assume nothing about the machine: no network access at runtime, no elevation, no dependence on the user
profile. How the engine realises this — the module-path mechanics that make the vendored copies win, the one-time fix for a network user
path, and no gallery at runtime — belongs to the engine twin.

### How this is enforced

- **Vendoring** — every module dependency is committed under `pwsh/.vendor/`
  ([controlling-module-dependencies](controlling-module-dependencies.md#rule-adr-auto-depm-internalvendored)), so a run needs no network.
- **`Install-VendorModule`** — the only supported way to add a vendored module; it runs once at authoring time, not at runtime.
- **User-space installers** — the tool installers use per-user package managers; `Test-ToolRequiresElevation` answers whether a tool's
  install needs elevation, and the provisioning loops skip and report such a tool.
- **The module-path mechanics** — the vendored-copy-wins loader surgery and the network-share warning live in the pwsh twin.

## Consequences

- The automation works behind firewalls and proxies with no network access at runtime, and provisions fully without local admin.
- Machine-specific slowness has environmental fixes where the source form requires them: the module-path mechanics live in the pwsh twin,
  and a source-mode devbox mitigates the cold-import antivirus cost with an exclusion.
- An installed build loads one merged function file per module, so its cold import opens a few dozen function files rather than hundreds,
  while the source a developer edits keeps one function per file.
