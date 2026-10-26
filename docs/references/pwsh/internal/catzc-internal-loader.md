# pwsh/.internal/Catzc.Internal.Loader.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

The always-loaded entry point for `.internal` shared code. It is the one thing the generated `importer.ps1` shim imports unconditionally,
and — unlike the transient bootstrap and importer overlay — it **stays in the session** for the whole life of the shell. Its export
`Import-InternalModule` is how every other `.internal` shared module is loaded: by the importer during startup, and by a post-import `Catzc`
cover function that needs to reach the same shared code afterward. Its other export, `Test-IsRunningInPipeline`, is the one
pipeline-detection function.

## What it does

The `.internal` folder holds code that both layers of the toolset must call — the pre-module **bootstrap** (which runs before any `Catzc`
module exists) and the **`Catzc` modules** (which run after). Rather than duplicate that code across the two layers, it lives once under
`.internal` and both sides load it through this loader (see [one-living-version](../../../drs/principles/one-living-version.md)). Because
the loader itself is what provides `Import-InternalModule`, it cannot bootstrap itself — so the shim imports it directly, first, and never
removes it. A resident cover function on a hot path can therefore call `Import-InternalModule Types` (or `Vendor`) and delegate, paying
nothing when the shared module is already loaded.

Because it is loaded first in both run modes and never removed, the loader also holds the one pipeline-detection function,
`Test-IsRunningInPipeline` (see [pipeline-detection](../../../drs/flow/pipeline-detection.md)). The bootstrap's C#-types pre-pass runs
before any `Catzc` module loads, and it calls the same function as every module, which needs no import step to reach it.

`Import-InternalModule` is **idempotent**: it takes the bare area name of a shared module — `Types` resolves to
`.internal/Catzc.Internal.Types.psm1` — and is a no-op when that module is already loaded, so the guard on a cover function's hot path costs
nothing. Its `-Force` switch reloads even when already present; the importer passes it on its own initial load so a devbox re-import (the
cache ADR's invalidation boundary) picks up edits to a shared module, the same "re-run the importer to invalidate" contract the C# type
cache follows.

## Functions

- `Import-InternalModule` — load a `.internal` shared module once into the global session by bare area name (`Types`, `Vendor`, `Bootstrap`,
  `TestKit`); idempotent, with `-Force` to reload across the re-import invalidation boundary.
- `Write-ImporterMessage` — the `[Importer.ps1]`-prefixed console writer the whole importer uses before `Write-Message` is available;
  `-StateChange` puts a line on the importer's verbose load record (ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE). It lives here because the
  loader stays loaded: the transient bootstrap and the post-prompt janitors both reach it.
- `Set-ImporterVerbosity` — hands the importer's `-Verbose` to `Write-ImporterMessage -StateChange`, for the life of the session.
- `Test-IsRunningInPipeline` — return whether the session runs inside a CI/CD pipeline (Azure DevOps or GitHub Actions); the one place the
  detection variables are read.

## Related

- ADR: [one-living-version](../../../drs/principles/one-living-version.md) — the two-layer shared code this loader exists to serve.
- ADR: [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — the loader is a sanctioned `.psm1`, not a function file.
- ADR: [caching](../../../drs/automation/caching.md) — the re-import invalidation boundary `-Force` honours.
- ADR: [pipeline-detection](../../../drs/flow/pipeline-detection.md) — the one detection function the loader carries.
- Reference: the [internal area overview](index.md) and the shared modules it loads — [Types](catzc-internal-types.md),
  [Vendor](catzc-internal-vendor.md), [Bootstrap](catzc-internal-bootstrap.md), [TestKit](catzc-internal-test-kit.md).

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.Loader — the always-loaded entry point for .internal shared code.

The .internal folder holds code that BOTH the bootstrap (which runs before any Catzc module exists) and the
Catzc modules (which run after) must call — the single home for what would otherwise be duplicated across the
two layers (see
[PDR-ONELIVE](/docs/drs/principles/one-living-version.md)). This loader is the one thing the importer loads
unconditionally; it stays in the session (it is NOT removed with Bootstrap), so a post-import Catzc cover
function can ensure a shared module is present before delegating to it. Because it is loaded first in both run
modes, it also carries the one pipeline-detection function, Test-IsRunningInPipeline, and the one VS Code
detection function, Test-IsRunningInVsCode, which the bootstrap's C#-types pre-pass and the Catzc modules both call.
```

## comment:2

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...`, written with `#`.

```text
.SYNOPSIS
    Loads a .internal shared module once into the global session (idempotent).
.DESCRIPTION
    Idempotent, so a hot-path cover function pays nothing; only the importer's first load passes -Force.
    [comment:2](/docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md#comment2)
.PARAMETER Name
    The bare area name of the shared module — 'Types' resolves to .internal/Catzc.Internal.Types.psm1.
.PARAMETER Force
    Reload even when the module is already loaded (the importer's initial load uses this).
.EXAMPLE
    Import-InternalModule Types
    Ensures Catzc.Internal.Types is loaded, then the caller can use Get-CombinedTypeHash.
```

## comment:3

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Returns true if the current session is running inside a CI/CD pipeline.
.DESCRIPTION
    It lives in the always-loaded loader so the bootstrap pre-pass and every module ask the same function.
    [comment:3](/docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md#comment3)
.EXAMPLE
    Test-IsRunningInPipeline
.EXAMPLE
    if (Test-IsRunningInPipeline) { Write-Verbose 'Running in CI' }
```

## comment:4

Above `[bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS`, written with `#`.

```text
Azure DevOps sets TF_BUILD=True
GitHub Actions sets GITHUB_ACTIONS=true
```

## comment:5

Above `function Write-ImporterMessage {`, written with `#`.

```text
.SYNOPSIS
    Writes a bootstrap/importer console message, prefixed to match Write-Message's [Caller] style.
.DESCRIPTION
    Runs before Write-Message exists, so this is the importer's one writer chokepoint, silent during a Pester run. It lives in the
    loader, which stays loaded, so a janitor line after the import still reaches it.
    [comment:1](/docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md#comment5)
.PARAMETER Message
    The message text.
.PARAMETER ForegroundColor
    Optional text color (e.g. DarkGray for diagnostics, Yellow for warnings). Not applied to a -StateChange line.
.PARAMETER StateChange
    The line announces a state change of the importer's own load sequence: write it on the verbose stream.
```

## comment:6

Above `$script:importerVerbose = $false`, written with `#`.

```text
Whether Write-ImporterMessage -StateChange lines are shown. Module state, so it lives exactly as long as the
loader: a fresh import reloads the loader and starts it at $false.
```

## comment:7

Above `function Set-ImporterVerbosity {`, written with `#`.

```text
.SYNOPSIS
    Sets whether the importer's state-change lines (Write-ImporterMessage -StateChange) are shown.
.DESCRIPTION
    The bootstrap and vendor functions do not inherit -Verbose, so Invoke-Importer hands the setting over here once.
    [comment:3](/docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md#comment7)
.PARAMETER Enabled
    Show the state-change lines on the verbose stream.
```

## comment:8

Above `function Test-IsRunningInVsCode {`, written with `#`.

```text
VS Code marks every terminal it opens, the PowerShell extension's own host included; this is the one reader of that
mark.
```

## comment:9

Above `function Test-IsInteractiveHost {`, written with `#`.

```text
A host that runs -File, -Command or -EncodedCommand, or runs -NonInteractive, exits when its command ends and never
shows a prompt, unless -NoExit keeps it open.
```

## comment:10

Above `function Enable-DeferredJanitors {`, written with `#`.

```text
The console session's janitors run once the first prompt has shown: the first render is untouched, the second runs the
action and restores the prompt.
```
