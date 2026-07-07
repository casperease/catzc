# ADR: Parameter design — the PowerShell layer over sensible-defaults

## Rules: ADR-PSPARAM

### Rule ADR-PSPARAM:1

A function's parameter surface applies [sensible-defaults](../sensible-defaults.md) (`ADR-DEFAULT`) with the PowerShell mechanics below: the
common call stays short because the parameter kinds carry the intent.

- [The primary argument is positional](#the-primary-argument-is-positional)

### Rule ADR-PSPARAM:2

Use positional parameters for the primary argument — the most important parameter is `Position = 0` so the caller can skip the name
(`Invoke-Poetry 'install'`).

- [The primary argument is positional](#the-primary-argument-is-positional)

### Rule ADR-PSPARAM:3

Use `[switch]`, not `[bool]`, for opt-in behavior that is off by default. Switches are self-documenting at the call site: `-PassThru` over
`-PassThru $true`.

- [Switches, not booleans](#switches-not-booleans)

## Context

[sensible-defaults](../sensible-defaults.md) fixes the doctrine: the zero-argument call works, defaults come from configuration, and a
parameter is mandatory only when no default makes sense. This ADR is the PowerShell layer under it — how the parameter surface itself is
shaped so the common invocation reads naturally.

The neighbouring parameter rules live where their hazards live: defaulting a `[string]` with `??` never works, and reassigning a
`Validate*`-attributed parameter re-fires its validator ([automatic-variable-pitfalls](automatic-variable-pitfalls.md), `ADR-AUTOVAR:6`/
`ADR-AUTOVAR:7`); the side-effect kill switch is an explicit `-DryRun` switch
([prefer-dryrun-over-shouldprocess](prefer-dryrun-over-shouldprocess.md)); and inputs are asserted at entry
([fail-fast-with-asserts](../fail-fast-with-asserts.md)).

### The primary argument is positional

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

## Decision

The primary argument is positional (`Position = 0`); opt-in behavior is a `[switch]` that is off by default. Secondary inputs are named
parameters.

### How this is enforced

- **The doctrine layer** — what defaults exist and where they come from is [sensible-defaults](../sensible-defaults.md) (`ADR-DEFAULT`);
  this ADR only fixes the parameter mechanics.
- **The exemplars** — the `Invoke-*` family (`Invoke-Executable`, `Invoke-Poetry`, `Invoke-Python`) is the pattern new functions copy.
- **Code review** — a `[bool]` where a `[switch]` belongs, or a mandatory named parameter for the obvious primary argument, is rejected
  against this ADR.

## Consequences

- Call sites read as intent: `Invoke-Poetry 'install' -PassThru` states the action and the one opted-in behavior, nothing else.
- Switch propagation is mechanical (`-DryRun:$DryRun`), so a flag travels a call chain without boolean plumbing.
- The cost is one judgment per function — which parameter is primary — made once by the author instead of on every call.

## Dora explains:

DORA's research on code maintainability shows that clear interfaces reduce cognitive load—and well-designed parameters make call sites
self-documenting. Positional primaries and switches for opt-in behavior surface intent at the call site, eliminating named-parameter noise
and making functions easier to understand and reuse.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — clear parameter surfaces reduce the burden of understanding
  what each call does.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — self-documenting call sites serve as examples; positional
  and switch conventions are widely understood.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
