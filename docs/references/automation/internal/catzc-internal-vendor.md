# Catzc.Internal.Vendor

The shared vendored-module loader. It imports the third-party modules under `automation/.vendor/<Name>/<Version>/` into the session, and it
lives in `.internal` for the same reason the other shared libraries do: vendored modules are loaded **before** any `Catzc` module exists
(the importer loads dependencies first), so the loader cannot live in a `Catzc` module — yet it must also be callable **after** import, by
the [Catzc.Base.Vendor](../catzc-base-vendor.md) cover functions that delegate to it. One implementation, two callers (see
[one-living-version](../../../adr/principles/one-living-version.md)). Like Types and the Loader, it is **resident** — kept in the session,
not removed with the transient bootstrap — and is loaded on demand through `Import-InternalModule Vendor`.

## What it does

`Import-VendorModules` imports every `automation/.vendor/<Name>/<Version>/` module into the global session so the vendored version wins over
any system-installed copy. For each module it:

- **removes any already-loaded system copy** and strips that module's system paths from `$env:PSModulePath`, so auto-loading cannot
  resurrect the system version after the vendored one imports;
- **skips a module already loaded from the vendor path** (re-importing a module that loaded .NET assemblies can fail in-process), and
  **throws** if the on-disk version changed under a still-loaded one — that needs a session restart, so it says so;
- **defers the modules named in `-Lazy`** (e.g. Pester, PSScriptAnalyzer) rather than importing them eagerly, prepending the vendor root to
  `PSModulePath` so they still autoload on first use without slowing shell startup;
- **tolerates an already-in-process assembly** (e.g. the VS Code Extension Console) by skipping rather than failing;
- with `-DiagnoseLoadTime`, **emits a per-module import time** — a vendor import loads the module's .NET assemblies, which an enterprise
  antivirus scans on first load, so isolating that cost per module makes a slow startup measurable rather than guessed at.

`-VendorRoot` is the vendor directory (it skips silently when the path does not exist). Vendoring modules this way — checked-in versions
loaded without a gallery restore — is the subject of the
[vendor-toolset-dependencies](../../../adr/automation/vendor-toolset-dependencies.md) ADR.

## Functions

- `Import-VendorModules` — import every vendored module from a vendor root so the checked-in version takes precedence; deferring the modules
  named in `-Lazy` to autoload on first use.

## Related

- ADR: [vendor-toolset-dependencies](../../../adr/automation/vendor-toolset-dependencies.md) — determinism without a restore step.
- ADR: [one-living-version](../../../adr/principles/one-living-version.md) — why the loader is shared by both layers.
- ADR: [use-ps1-not-psm1](../../../adr/automation/powershell/use-ps1-not-psm1.md) — the loader is a sanctioned `.psm1`.
- Reference: [Catzc.Base.Vendor](../catzc-base-vendor.md) — the post-import cover functions that add, remove, and validate vendored modules
  and delegate here; the [internal area overview](index.md).
