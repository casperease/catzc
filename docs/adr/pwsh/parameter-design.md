---
catzc:
  derived:
    path: docs/adr/pwsh/parameter-design.md
    kind: adr
    body_sha: fc5a12fcf30f
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PWSH-AUTOVAR#6
      - ADR-PWSH-AUTOVAR#7
      - ADR-PWSH-PARAM#2
      - ADR-PWSH-PARAM#4
      - ADR-PWSH-PESTER#3
---

# ADR: Parameter design — the PowerShell layer over sensible-defaults

## Rules: ADR-PWSH-PARAM

### Rule ADR-PWSH-PARAM:1

A function's parameter surface applies [sensible-defaults](../automation/sensible-defaults.md) (`ADR-AUTO-DEFAULT`) with the PowerShell
mechanics below: the common call stays short because the parameter kinds carry the intent.

- [Positional primary argument](#positional-primary-argument)

### Rule ADR-PWSH-PARAM:2

Use positional parameters for the primary argument — the most important parameter is `Position = 0` so the caller can skip the name
(`Invoke-Poetry 'install'`).

- [Positional primary argument](#positional-primary-argument)

### Rule ADR-PWSH-PARAM:3

Use `[switch]`, not `[bool]`, for opt-in behavior that is off by default. Switches are self-documenting at the call site: `-PassThru` over
`-PassThru $true`.

- [Switches, not booleans](#switches-not-booleans)

### Rule ADR-PWSH-PARAM:4

The resolution order of [ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6) is, in PowerShell, one parameter
declaration: the default expression reads the configured value — `[LinkWrap] $Wrap = (Get-Config -Config links).wrap` — which PowerShell
evaluates only when the caller omits the parameter, and which `Get-Help` shows. The function body never fills an empty parameter in. A
default may derive from a parameter declared before it (`[string] $Label = (Split-Path $Path -Leaf)`). The body fills in only what a
declaration cannot express, and says why at the fill-in: a value derived from pipeline-bound input (bound after defaults are evaluated), a
value relative to a parameter declared after it, or a pass-through parameter many callers forward empty
(`Write-QualityGateReport -OutputFolder`), where an explicit empty argument would override a declared default.

- [Configurable parameters](#configurable-parameters)

## Context

[sensible-defaults](../automation/sensible-defaults.md) fixes the doctrine: the zero-argument call works, defaults come from configuration,
and a parameter is mandatory only when no default makes sense. This ADR is the PowerShell layer under it — how the parameter surface itself
is shaped so the common invocation reads naturally.

The neighbouring parameter rules live where their hazards live: defaulting a `[string]` with `??` never works, and reassigning a
`Validate*`-attributed parameter re-fires its validator ([automatic-variable-pitfalls](automatic-variable-pitfalls.md),
`ADR-PWSH-AUTOVAR#6`/ `ADR-PWSH-AUTOVAR#7`); the side-effect kill switch is an explicit `-DryRun` switch
([dry-run](../automation/dry-run.md)); and inputs are asserted at entry ([fail-fast-with-asserts](../automation/fail-fast-with-asserts.md)).

### Positional primary argument

`The primary argument is positional`

The one value a caller always supplies goes first and needs no name:

```powershell
# GOOD — positional for the primary argument, switches for behavior
Invoke-Poetry 'install'
Invoke-Poetry 'install' -PassThru

# BAD — named parameters for everything
Invoke-Poetry -Arguments 'install' -PassThru
```

The primary argument is the answer to "what is this call about" — the command string for an `Invoke-*` wrapper, the template name for
`Build-Bicep`. Secondary inputs stay named, so the call site reads as the primary thing plus explicit modifiers.

### Switches, not booleans

Opt-in behavior that is off by default is a `[switch]` — `-PassThru`, `-DryRun`, `-Silent`, `-Force` — never a `[bool]` parameter. A switch
is self-documenting at the call site (its presence is the opt-in), defaults to off with no declaration, and propagates cleanly down a call
chain as `-PassThru:$PassThru`. A `[bool]` forces every caller to write `$true`, reads ambiguously (`-Enabled $false` — is that the
default?), and invites `$null` coercion surprises.

### Configurable parameters

[sensible-defaults](../automation/sensible-defaults.md#one-resolution-order) fixes the resolution order of a configurable setting: the
explicit value, else the module's configuration, else the sensible default declared once on the config type. In PowerShell that order is one
parameter declaration:

```powershell
# GOOD — the default expression IS the configured value; the config type supplies the sensible default
param([Catzc.Base.QualityGates.LinkWrap] $Wrap = (Get-Config -Config links).wrap)

# BAD — the body fills the gap: a second place that knows the default, invisible to Get-Help
param([string] $Wrap)
if (-not $Wrap) { $Wrap = (Get-Config -Config links).wrap }
```

PowerShell evaluates a default expression only when the caller omits the parameter, so an explicit `-Wrap Off` never reads the config at
all. A default expression may read an earlier parameter (`[string] $Version = (Get-ToolConfig -Tool $Tool).version`), so a generic function
keyed by its primary argument declares its default the same way. A wrapper that forwards the parameter declares the same default, because an
explicit empty value passed down the chain would win over the callee's default. A value that is derived rather than configured stays in the
body: one chosen from several sources in turn, or one that applies only when another argument is absent (`-ModuleProfile` when no `-Module`
is given). The expression runs in the module's scope, so a test isolates it by mocking `Get-Config` (`ADR-PWSH-PESTER#3`) — the same seam
the function uses.

## Decision

The primary argument is positional (`Position = 0`); opt-in behavior is a `[switch]` that is off by default. A configurable parameter
declares the configured value as its default. Secondary inputs are named parameters.

### How this is enforced

- **The doctrine layer** — what defaults exist and where they come from is [sensible-defaults](../automation/sensible-defaults.md)
  (`ADR-AUTO-DEFAULT`); this ADR only fixes the parameter mechanics.
- **Custom PSScriptAnalyzer rules** (`automation/.scriptanalyzer/ParameterDesign.psm1`) — `Measure-PrimaryArgumentPosition` flags a function
  whose one mandatory parameter lacks `Position = 0` (ADR-PWSH-PARAM#2), and `Measure-ParameterFillIn` flags a body that fills an empty
  parameter in (ADR-PWSH-PARAM#4).
- **The exemplars** — the `Invoke-*` family (`Invoke-Executable`, `Invoke-Poetry`, `Invoke-Python`) is the pattern new functions copy.
- **Code review** — a `[bool]` where a `[switch]` belongs is rejected against this ADR.

## Consequences

- Call sites read as intent: `Invoke-Poetry 'install' -PassThru` states the action and the one opted-in behavior, nothing else.
- Switch propagation is mechanical (`-DryRun:$DryRun`), so a flag travels a call chain without boolean plumbing.
- The cost is one judgment per function — which parameter is primary — made once by the author instead of on every call.
