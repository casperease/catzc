# ADR: Prefer an explicit -DryRun switch over the ShouldProcess subsystem

## Rules: ADR-PWSH-DRYRUN

### Rule ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS

Suppress `PSUseShouldProcessForStateChangingFunctions` with a justification referencing this ADR wherever the analyzer nags, since it pushes
the pattern we reject.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-DRYRUN-DRYRUNSWITCH

In pwsh, the dry-run parameter of ADR-AUTO-DRYRUN-SIDEEFFECTSTAKEDRYRUN is `[switch] $DryRun`. No function declares
`[CmdletBinding(SupportsShouldProcess)]` or calls `$PSCmdlet.ShouldProcess`, so no function carries `-WhatIf`.

- [Why not ShouldProcess](#why-not-shouldprocess)
- [The idiom](#the-idiom)

### Rule ADR-PWSH-DRYRUN-EARLYRETURNBRANCH

In pwsh, the dry-run branch of ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT is `if ($DryRun) { return <the action> }` before the side effect: the
planned action goes to the output stream, where a caller or test captures it, and nothing is written to the host as narration.

- [The idiom](#the-idiom)

### Rule ADR-PWSH-DRYRUN-PASSDRYRUNON

In pwsh, ADR-AUTO-DRYRUN-PROPAGATEEXPLICITLY's propagation is `-DryRun:$DryRun` on every call to a function that takes the switch. No
preference variable — `$WhatIfPreference` or one of our own — carries it.

- [What we use instead](#what-we-use-instead)

### Rule ADR-PWSH-DRYRUN-NOCONFIRM

In pwsh, ADR-AUTO-DRYRUN-NOCONFIRMATION means no `-Confirm`, no `ConfirmImpact`, and no `$ConfirmPreference`: a destructive function is safe
because it is idempotent, not because the Confirm subsystem asks.

- [Why not ShouldProcess](#why-not-shouldprocess)

## Context

[dry-run](../dry-run.md) decides that every side-effecting function takes an explicit dry-run parameter, returns its plan, and passes the
parameter on by hand. PowerShell ships a built-in mechanism that looks like the same thing: `[CmdletBinding(SupportsShouldProcess)]` plus
`$PSCmdlet.ShouldProcess(...)`, which adds the `-WhatIf` and `-Confirm` common parameters. PSScriptAnalyzer even nags for it
(`PSUseShouldProcessForStateChangingFunctions`). It looks like the idiomatic choice. We deliberately do **not** use it.

### Why not ShouldProcess

`Why ShouldProcess is the wrong tool here`

- **Its output is not capturable, so it is not testable.** The `-WhatIf` narration ("What if: Performing the operation …") is written
  **directly to the host** — not the information stream, and unaffected by `-InformationAction`/`6>$null`. A test cannot capture it to
  assert on, and it cannot be suppressed, so it spams every test run. Worse, `ShouldProcess` only _returns a bool and narrates_; the
  function cannot **return the action it would take** for a test to inspect.

- **It is special plumbing that is easy to get subtly wrong.** Making `-WhatIf` actually safe requires three separate, invisible steps:
  declare `SupportsShouldProcess`, guard **every** side effect with `$PSCmdlet.ShouldProcess(...)` at exactly the right place, and propagate
  `-WhatIf:$WhatIfPreference` to **every** nested cmdlet that has its own side effects. Miss any one and the side effect fires under
  `-WhatIf` — a silent, dangerous failure that looks like it worked.

- **It is preference-variable magic.** `-WhatIf`/`-Confirm` behaviour depends on `$WhatIfPreference`, `$ConfirmPreference`, and
  `ConfirmImpact` inheritance down the call chain — implicit, surprising, and hard to reason about.

### What we use instead

A plain **`[switch] $DryRun`**, passed on as `-DryRun:$DryRun`. `Invoke-Executable`'s own note states the rationale:

> uses `-DryRun` instead of ShouldProcess/`-WhatIf` because ShouldProcess writes to the host (not capturable) and we need the command string
> returned via `Write-Output` for testability. `-Confirm` is not needed for CLI commands.

## Decision

Side-effecting functions take `[switch] $DryRun`. Do **not** use `[CmdletBinding(SupportsShouldProcess)]`, `$PSCmdlet.ShouldProcess`,
`-WhatIf`, `-Confirm`, or `ConfirmImpact`.

### The idiom

From `Invoke-Executable` — a `[switch] $DryRun` that short-circuits to a returned, capturable value:

```powershell
function Invoke-Executable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Command,
        [switch] $DryRun
        # ...
    )

    if ($DryRun) {
        return $Command          # the action, RETURNED — capturable, assertable, no host narration
    }
    # ... actually execute ...
}
```

A test then asserts the plan without any side effect or host spam:

```powershell
It 'in dry-run, returns the command and does not execute' {
    Invoke-Executable 'az group create ...' -DryRun | Should -Match '^az group create'
    Should -Invoke Invoke-ExecutableStreamed -Times 0
}
```

### How this is enforced

- **The exemplars.** `Invoke-Executable` and the `Invoke-*` family show the switch; `Remove-PermanentPath` shows the analyzer-suppression
  form of ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS.
- **Code review.** A new `SupportsShouldProcess` / `$PSCmdlet.ShouldProcess` / `-WhatIf` is rejected in review in favour of `-DryRun`.
- **The suppression.** Each function the analyzer flags carries a `SuppressMessageAttribute` for
  `PSUseShouldProcessForStateChangingFunctions` whose justification cites ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS, so a reader of the function
  finds the reason.

## Consequences

- A dry-run call returns the planned action and a `Should -Invoke … -Times 0` confirms nothing ran.
- No `SupportsShouldProcess` exists in the codebase, so no un-suppressable `What if:` lines surface in the test run.
- No `$WhatIfPreference`/`$ConfirmPreference` reasoning across the call chain.
- The cost: we forgo the engine's free `-WhatIf`/`-Confirm` common parameters and the analyzer's blessing (suppressed with a pointer here).
