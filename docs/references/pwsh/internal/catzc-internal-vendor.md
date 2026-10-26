# pwsh/.internal/Catzc.Internal.Vendor.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

The shared vendored-module loader. It imports the third-party modules under `pwsh/.vendor/<Name>/<Version>/` into the session, and it lives
in `.internal` for the same reason the other shared libraries do: vendored modules are loaded **before** any `Catzc` module exists (the
importer loads dependencies first), so the loader cannot live in a `Catzc` module — yet it must also be callable **after** import, by the
[Catzc.Base.Vendor](../base-vendor/index.md) cover functions that delegate to it. One implementation, two callers (see
[one-living-version](../../../drs/principles/one-living-version.md)). Like Types and the Loader, it is **resident** — kept in the session,
not removed with the transient bootstrap — and is loaded on demand through `Import-InternalModule Vendor`.

## What it does

`Import-VendorModules` imports every `pwsh/.vendor/<Name>/<Version>/` module into the global session so the vendored version wins over any
system-installed copy. For each module it:

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
[vendor-toolset-dependencies](../../../drs/automation/pwsh/vendor-toolset-dependencies.md) ADR.

## Functions

- `Import-VendorModules` — import every vendored module from a vendor root so the checked-in version takes precedence; deferring the modules
  named in `-Lazy` to autoload on first use.

## Related

- ADR: [vendor-toolset-dependencies](../../../drs/automation/pwsh/vendor-toolset-dependencies.md) — determinism without a restore step.
- ADR: [one-living-version](../../../drs/principles/one-living-version.md) — why the loader is shared by both layers.
- ADR: [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — the loader is a sanctioned `.psm1`.
- Reference: [Catzc.Base.Vendor](../base-vendor/index.md) — the post-import cover functions that add, remove, and validate vendored modules
  and delegate here; the [internal area overview](index.md).

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.Vendor — the shared vendor-module loader.

Loading the vendored modules under pwsh/.vendor/<Name>/<Version>/ happens BEFORE any Catzc module
exists (the importer loads vendor dependencies first), so the implementation cannot live in a Catzc module.
It also must be callable AFTER import by the Catzc.Base.Vendor cover functions that delegate to it — the
single home for what both layers share (see
[PDR-ONELIVE](/docs/drs/principles/one-living-version.md)). Like the other
.internal shared libraries (Types, the Loader), this module stays in the session; it is NOT removed with
the transient bootstrap. Loaded on demand through Import-InternalModule Vendor.
```

## comment:2

Above `function Import-VendorModules {`, written with `#`.

```text
.SYNOPSIS
    Imports third-party modules from a vendor directory.
.DESCRIPTION
    The system copy leaves PSModulePath first so the vendored version wins; a changed on-disk version needs a restart.
    [comment:2](/docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md#comment2)
.PARAMETER VendorRoot
    Path to the vendor directory. Skips silently if the path does not exist.
.PARAMETER Lazy
    Deferred modules cost nothing at startup and still autoload on first use, since the vendor root heads PSModulePath.
    [comment:3](/docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md#comment3)
.PARAMETER DiagnoseLoadTime
    Emit a per-vendor-module import time (surfaced by importer.ps1 -DiagnoseLoadTime).
.EXAMPLE
    Import-VendorModules -VendorRoot $vendorRoot -Lazy 'Pester', 'PSScriptAnalyzer'
```

## comment:3

Above `[switch]$DiagnoseLoadTime`, written with `#`.

```text
Emit a per-vendor-module import time. Surfaced by importer.ps1 -DiagnoseLoadTime. A vendor import
loads the module's .NET assemblies (e.g. YamlDotNet for powershell-yaml), which an enterprise
antivirus scans on first load — the prime suspect for a slow startup. This isolates that cost
per module so it's measured, not guessed. Off = no overhead.
```

## comment:4

Above `$vendorDirs = [System.IO.DirectoryInfo]::new($VendorRoot).GetDirectories()`, written with `#`.

```text
One level, inline: this module loads before the walker exists
([ADR-PWSH-ENUM-EARLYLOADINGCODE](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-earlyloadingcode)).
```

## comment:5

Above `if ($existing -and $existing.ModuleBase -like "$VendorRoot*") {`, written with `#`.

```text
Already loaded from our vendor path — skip (re-importing can fail
if the module loaded .NET assemblies that can't be replaced in-process)
```

## comment:6

Above `$before = @($env:PSModulePath -split $sep)`, written with `#`.

```text
Remove system paths for this module from PSModulePath so auto-loading
cannot resurrect the system version after we import the vendored one
```

## comment:7

Above `if ($existing) {` (occurrence 2), written with `#`.

```text
The load, the system copy it replaced, and the PSModulePath entries it dropped are one state change of
the session, announced on one line
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)) on
the importer's verbose record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)).
```
