# ADR: Prefer an explicit `-DryRun` switch over the ShouldProcess subsystem

## Rules: ADR-AUTO-DRYRUN

### Rule ADR-AUTO-DRYRUN:1

Add a `[switch] $DryRun` parameter to any function that performs a side effect (deploy, install, delete, tag, CLI invocation).

- [What we use instead](#what-we-use-instead)
- [The idiom](#the-idiom)

### Rule ADR-AUTO-DRYRUN:2

Branch before the side effect: the dry-run path returns the planned action (command string, resolved target) and mutates nothing. The result
must be observable by return value or captured stream, never only host narration.

- [The idiom](#the-idiom)
- [Why ShouldProcess is the wrong tool here](#why-shouldprocess-is-the-wrong-tool-here)

### Rule ADR-AUTO-DRYRUN:3

Propagate `-DryRun:$DryRun` explicitly down the call chain. No preference variables, no implicit inheritance — pass the flag like any other
argument.

- [What we use instead](#what-we-use-instead)

### Rule ADR-AUTO-DRYRUN:4

Do not reach for `-Confirm`. A genuinely destructive operation makes itself safe by idempotent design (a no-op when there is nothing to
remove), not by the Confirm subsystem.

- [Decision](#decision)
- [What we use instead](#what-we-use-instead)

### Rule ADR-AUTO-DRYRUN:5

Suppress `PSUseShouldProcessForStateChangingFunctions` with a justification referencing this ADR wherever the analyzer nags, since it pushes
the pattern we reject.

- [How this is enforced](#how-this-is-enforced)

## Context

Side-effecting automation functions — those that deploy, install, delete, tag, or shell out to a CLI — need a "don't actually do it" mode,
for previewing and for tests that must verify _what would happen_ without making it happen. PowerShell ships a built-in mechanism for this:
`[CmdletBinding(SupportsShouldProcess)]` plus `$PSCmdlet.ShouldProcess(...)`, which adds the `-WhatIf` and `-Confirm` common parameters.
PSScriptAnalyzer even nags for it (`PSUseShouldProcessForStateChangingFunctions`). It looks like the idiomatic choice. We deliberately do
**not** use it.

### Why ShouldProcess is the wrong tool here

- **Its output is not capturable, so it is not testable.** The `-WhatIf` narration ("What if: Performing the operation …") is written
  **directly to the host** — not the information stream, and unaffected by `-InformationAction`/`6>$null` (verified). A test cannot capture
  it to assert on, and it cannot be suppressed, so it spams every test run. Worse, `ShouldProcess` only _returns a bool and narrates_; the
  function cannot **return the action it would take** for a test to inspect. Good tests assert on a return value or a mockable call —
  ShouldProcess gives neither.

- **It is special plumbing that is easy to get subtly wrong.** Making `-WhatIf` actually safe requires three separate, invisible steps:
  declare `SupportsShouldProcess`, guard **every** side effect with `$PSCmdlet.ShouldProcess(...)` at exactly the right place, and propagate
  `-WhatIf:$WhatIfPreference` to **every** nested cmdlet that has its own side effects. Miss any one and the side effect fires under
  `-WhatIf` — a silent, dangerous failure that looks like it worked. The ceremony is not visible at the call site, and people forget it.

- **It is preference-variable magic.** `-WhatIf`/`-Confirm` behaviour depends on `$WhatIfPreference`, `$ConfirmPreference`, and
  `ConfirmImpact` inheritance down the call chain — implicit, surprising, and hard to reason about. An explicit switch you pass by hand has
  none of that ambiguity.

### What we use instead

A plain **`[switch] $DryRun`**. When set, the function **returns the action it would take** (the command string, the would-be target) and
performs **no** side effect. This is the established convention across the `Invoke-*` family and `Invoke-Executable`, whose own note states
the rationale:

> uses `-DryRun` instead of ShouldProcess/`-WhatIf` because ShouldProcess writes to the host (not capturable) and we need the command string
> returned via `Write-Output` for testability. `-Confirm` is not needed for CLI commands.

A `-DryRun` switch is a normal parameter: explicit, greppable, returns an assertable value, propagates by plain pass-through, and adds no
host noise.

## Decision

Side-effecting functions take an explicit `[switch] $DryRun`. Do **not** use `[CmdletBinding(SupportsShouldProcess)]`,
`$PSCmdlet.ShouldProcess`, `-WhatIf`, `-Confirm`, or `ConfirmImpact`.

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

- **The exemplars.** The `Tooling` group's `Invoke-*` family and `Invoke-Executable` are the patterns new side-effecting functions copy;
  `Remove-PermanentPath` shows the analyzer-suppression form.
- **Code review.** A new `SupportsShouldProcess` / `$PSCmdlet.ShouldProcess` / `-WhatIf` is rejected in review in favour of `-DryRun`.
- **Tests stay quiet and assertive.** Because dry-run is a returned value (not host narration), tests capture it directly — no
  un-suppressable `What if:` lines polluting the run (see [test-automation](../test-automation.md) and
  [console-output-matters](console-output-matters.md)).

## Consequences

- Side effects are previewable and testable by **return value** — a dry-run call returns the planned action and a
  `Should -Invoke … -Times 0` confirms nothing ran.
- No host spam: the run is clean because there is no engine `-WhatIf` narration written past the streams.
- No silent-failure mode from a forgotten `ShouldProcess` guard or an un-propagated `-WhatIf`.
- Behaviour is explicit and local — no `$WhatIfPreference`/`$ConfirmPreference` reasoning across the call chain.
- The cost: we forgo the engine's free `-WhatIf`/`-Confirm` common parameters and the analyzer's blessing (suppressed with a pointer here).
  We accept that — testability and a low-ceremony, hard-to-misuse API win.
- No `SupportsShouldProcess` exists in the codebase, so no un-suppressable `What if:` lines surface in the test run.
