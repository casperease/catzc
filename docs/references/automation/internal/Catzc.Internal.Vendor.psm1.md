---
catzc:
  derived:
    path: docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md
    kind: comment-page
    body_sha: "311d0c139fb6"
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-PWSH-ANNOUNCE#6
---

# automation/.internal/Catzc.Internal.Vendor.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`.

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

Section `.DESCRIPTION` of the comment-based help.

```text
Loads every automation/.vendor/<Name>/<Version>/ module into the global session, removing any
system-installed copy from $env:PSModulePath first so the vendored version takes precedence. Skips a
module already loaded from the vendor path, and throws if its on-disk version changed under a loaded one
(a session restart is required). Modules named in -Lazy are deferred (the vendor root is prepended to
PSModulePath so they still autoload on first use).
```

## comment:3

Section `.PARAMETER Lazy` of the comment-based help.

```text
Module names to defer rather than import eagerly (e.g. Pester, PSScriptAnalyzer) so they do not slow
shell startup; they autoload on first use from the vendor root.
```

## comment:4

Above `[switch]$DiagnoseLoadTime`.

```text
Emit a per-vendor-module import time. Surfaced by importer.ps1 -DiagnoseLoadTime. A vendor import
loads the module's .NET assemblies (e.g. YamlDotNet for powershell-yaml), which an enterprise
antivirus scans on first load — the prime suspect for a slow startup. This isolates that cost
per module so it's measured, not guessed. Off = no overhead.
```

## comment:5

Above `if ($existing -and $existing.ModuleBase -like "$VendorRoot*") {`.

```text
Already loaded from our vendor path — skip (re-importing can fail
if the module loaded .NET assemblies that can't be replaced in-process)
```

## comment:6

Above `$before = @($env:PSModulePath -split $sep)`.

```text
Remove system paths for this module from PSModulePath so auto-loading
cannot resurrect the system version after we import the vendored one
```

## comment:7

Above `if ($existing) {`.

```text
The load, the system copy it replaced, and the PSModulePath entries it dropped are one state change of
the session, announced on one line
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)) on
the importer's verbose record
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)).
```
