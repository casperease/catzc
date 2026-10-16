---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md
    folder: docs/references/automation/internal
    name: catzc-internal-vendor-psm1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "778706f0dcc0"
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-PWSH-ANNOUNCE#6
      - ADR-PWSH-ENUM#6
---

# automation/.internal/Catzc.Internal.Vendor.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.Vendor — the shared vendor-module loader.

Loading the vendored modules under automation/.vendor/<Name>/<Version>/ happens BEFORE any Catzc module
exists (the importer loads vendor dependencies first), so the implementation cannot live in a Catzc module.
It also must be callable AFTER import by the Catzc.Base.Vendor cover functions that delegate to it — the
single home for what both layers share (see
[ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)). Like the other
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
    [comment:2](/docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md#comment2)
.PARAMETER VendorRoot
    Path to the vendor directory. Skips silently if the path does not exist.
.PARAMETER Lazy
    Deferred modules cost nothing at startup and still autoload on first use, since the vendor root heads PSModulePath.
    [comment:3](/docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md#comment3)
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
([ADR-PWSH-ENUM#6](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum6)).
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
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)) on
the importer's verbose record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)).
```
