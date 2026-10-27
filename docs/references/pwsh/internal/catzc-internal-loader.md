# pwsh/.internal/Catzc.Internal.Loader.psm1

The always-loaded entry point for `.internal` shared code. It is the one thing the generated `importer.ps1` shim imports unconditionally,
and — unlike the transient bootstrap and importer overlay — it **stays in the session** for the whole life of the shell. Its export
`Import-InternalModule` is how every other `.internal` shared module is loaded: by the importer during startup, and by a post-import `Catzc`
cover function that needs to reach the same shared code afterward. Its other exports are the host and pipeline detection functions, the
deferred-janitor prompt hook, and the importer's console writer.

## What it does

The `.internal` folder holds code that both layers of the toolset must call — the pre-module **bootstrap** (which runs before any `Catzc`
module exists) and the **`Catzc` modules** (which run after). Rather than duplicate that code across the two layers, it lives once under
`.internal` and both sides load it through this loader (see [one-living-version](../../../drs/principles/one-living-version.md)). Because
the loader itself is what provides `Import-InternalModule`, it cannot bootstrap itself — so the shim imports it directly, first, and never
removes it. A resident cover function on a hot path can therefore call `Import-InternalModule Types` (or `Vendor`) and delegate, paying
nothing when the shared module is already loaded.

Because it is loaded first in both run modes and never removed, the loader also holds the detection functions: `Test-IsRunningInPipeline`
(see [pipeline-detection](../../../drs/automation/pwsh/pipeline-detection.md)) and `Test-IsRunningInVsCode`. The bootstrap's C#-types pre-pass runs
before any `Catzc` module loads, and it calls the same functions as every module, which need no import step to reach them.

`Import-InternalModule` is **idempotent**: it takes the bare area name of a shared module — `Types` resolves to
`.internal/Catzc.Internal.Types.psm1` — and is a no-op when that module is already loaded, so the guard on a cover function's hot path costs
nothing. Its `-Force` switch reloads even when already present; the importer passes it on its own initial load so a devbox re-import (the
cache ADR's invalidation boundary) picks up edits to a shared module, the same "re-run the importer to invalidate" contract the C# type
cache follows.

## Detection

- **Pipeline** — `Test-IsRunningInPipeline` is true when `TF_BUILD` is set (Azure DevOps) or `GITHUB_ACTIONS` is set (GitHub Actions); it
  lives here so the bootstrap pre-pass and every module ask the same function.
- **VS Code** — VS Code marks every terminal it opens, the PowerShell extension's own host included; `Test-IsRunningInVsCode` is the one
  reader of that mark.
- **Interactive host** — a host that runs `-File`, `-Command` or `-EncodedCommand`, or runs `-NonInteractive`, exits when its command ends
  and never shows a prompt, unless `-NoExit` keeps it open; `Test-IsInteractiveHost` reads the command line for that.

## Importer console messages

`Write-ImporterMessage` runs before `Write-Message` exists, so it is the importer's one writer chokepoint, prefixed to match
`Write-Message`'s `[Caller]` style and silent during a Pester run. It lives here because the loader stays loaded: a janitor line after the
import still reaches it. `-ForegroundColor` colours a line (not applied to a `-StateChange` line); `-StateChange` announces a state change
of the importer's own load sequence and writes it on the verbose stream.

Whether those lines are shown is module state that lives exactly as long as the loader: a fresh import reloads the loader and starts it
hidden. The bootstrap and vendor functions do not inherit `-Verbose`, so `Invoke-Importer` hands the setting over once through
`Set-ImporterVerbosity`.

## Deferred janitors

A console session's janitors run once the first prompt has shown. `Enable-DeferredJanitors` replaces the global `prompt` with a hook
(`Invoke-DeferredJanitorsPrompt`): the first render is untouched, the second runs the action and restores the previous prompt. With no
`-Action` the default loads the Importer overlay, runs `Invoke-ImporterJanitors` and removes the overlay again.

## Functions

- `Import-InternalModule` — load a `.internal` shared module once into the global session by bare area name (`Types`, `Vendor`, `Bootstrap`,
  `TestKit`, `Importer`); idempotent, with `-Force` to reload across the re-import invalidation boundary.
- `Write-ImporterMessage` — the `[Importer.ps1]`-prefixed console writer the whole importer uses before `Write-Message` is available;
  `-StateChange` puts a line on the importer's verbose load record (ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE).
- `Set-ImporterVerbosity` — hands the importer's `-Verbose` to `Write-ImporterMessage -StateChange`, for the life of the session.
- `Test-IsRunningInPipeline` — return whether the session runs inside a CI/CD pipeline (Azure DevOps or GitHub Actions); the one place the
  detection variables are read.
- `Test-IsRunningInVsCode` — return whether the session runs in a VS Code terminal.
- `Test-IsInteractiveHost` — return whether the host stays open to show a prompt.
- `Enable-DeferredJanitors` — install the prompt hook that runs the console session's janitors after the first prompt.
- `Invoke-DeferredJanitorsPrompt` — the hook itself; it restores the previous prompt once the action has run.

## Related

- ADR: [one-living-version](../../../drs/principles/one-living-version.md) — the two-layer shared code this loader exists to serve.
- ADR: [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — the loader is a sanctioned `.psm1`, not a function file.
- ADR: [caching](../../../drs/automation/caching.md) — the re-import invalidation boundary `-Force` honours.
- ADR: [pipeline-detection](../../../drs/automation/pwsh/pipeline-detection.md) — the one detection function the loader carries.
- Reference: the internal area overview and the shared modules it loads — `Types`, `Vendor`, `Bootstrap`, `TestKit`.
