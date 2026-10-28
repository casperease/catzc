# PowerShell: Parameter design — the pwsh rules over sensible-defaults

## Rules: ADR-PWSH-PARAM

### Rule ADR-PWSH-PARAM-SENSIBLEDEFAULTS

A function's parameter surface applies [sensible-defaults](../sensible-defaults.md) (`ADR-AUTO-DEFAULT`) with the PowerShell mechanics
below: the common call stays short because the parameter kinds carry the intent.

- [Positional primary argument](#positional-primary-argument)

### Rule ADR-PWSH-PARAM-POSITIONALPRIMARY

Use positional parameters for the primary argument — the most important parameter is `Position = 0` so the caller can skip the name
(`Invoke-Poetry 'install'`).

- [Positional primary argument](#positional-primary-argument)

### Rule ADR-PWSH-PARAM-SWITCHNOTBOOL

Use `[switch]`, not `[bool]`, for opt-in behavior that is off by default. Switches are self-documenting at the call site: `-PassThru` over
`-PassThru $true`.

- [Switches, not booleans](#switches-not-booleans)

### Rule ADR-PWSH-PARAM-RESOLUTIONORDER

The resolution order of [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../sensible-defaults.md#rule-adr-auto-default-oneresolutionorder) is, in
PowerShell, one parameter declaration: the default expression reads the configured value —
`[LinkWrap] $Wrap = (Get-Config -Config links).wrap` — which PowerShell evaluates only when the caller omits the parameter, and which
`Get-Help` shows. The function body never fills an empty parameter in. A default may derive from a parameter declared before it
(`[string] $Label = (Split-Path $Path -Leaf)`). The body fills in only what a declaration cannot express, and says why at the fill-in: a
value derived from pipeline-bound input (bound after defaults are evaluated), a value relative to a parameter declared after it, or a
pass-through parameter many callers forward empty (`Write-QualityGateReport -OutputFolder`), where an explicit empty argument would override
a declared default.

- [Configurable parameters](#configurable-parameters)

### Rule ADR-PWSH-PARAM-CASESENSITIVEPATTERN

A `ValidatePattern` whose pattern depends on case carries `Options = 'None'` or opens with the inline `(?-i)`: PowerShell matches a
`ValidatePattern` ignoring case unless its `Options` or the pattern say otherwise, so `^[A-Z]` alone accepts a lower-case value.

- [Case-sensitive patterns](#case-sensitive-patterns)

## Context

[sensible-defaults](../sensible-defaults.md) fixes the doctrine: the zero-argument call works, defaults come from configuration, and a
parameter is mandatory only when no default makes sense. This record realises it in pwsh: the shape of the parameter surface.

The neighbouring parameter rules live where their hazards live: defaulting a `[string]` with `??` never works, and reassigning a
`Validate*`-attributed parameter re-fires its validator ([automatic-variable-pitfalls](automatic-variable-pitfalls.md),
`ADR-PWSH-AUTOVAR-NOCOALESCEONSTRINGS`/ `ADR-PWSH-AUTOVAR-NOVALIDATEDREASSIGNMENT`); the side-effect kill switch is an explicit `-DryRun`
switch ([dry-run](../dry-run.md)); and inputs are asserted at entry ([fail-fast-with-asserts](../fail-fast-with-asserts.md)).

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
default?), and invites `$null` coercion surprises. A setting whose default comes from the configuration is not opt-in behavior: it is a
configurable parameter (see below), it may be on by default, and a `[bool]` is the type that lets the caller state either value, so its
default expression reads the configured value.

### Configurable parameters

The [resolution order](../sensible-defaults.md#one-resolution-order) is one parameter declaration:

```powershell
# GOOD — the default expression IS the configured value; the config type supplies the sensible default
param([Catzc.Base.QualityGates.LinkWrap] $Wrap = (Get-Config -Config links).wrap)

# BAD — the body fills the gap: a second place that knows the default, invisible to Get-Help
param([string] $Wrap)
if (-not $Wrap) { $Wrap = (Get-Config -Config links).wrap }
```

An explicit `-Wrap Off` never reads the config at all. A generic function keyed by its primary argument declares its default from that
argument (`[string] $Version = (Get-ToolConfig -Tool $Tool).version`). A wrapper that forwards the parameter declares the same default,
because an explicit empty value passed down the chain would win over the callee's default. A value that is derived rather than configured
stays in the body: one chosen from several sources in turn, or one that applies only when another argument is absent (`-ModuleProfile` when
no `-Module` is given). The expression runs in the module's scope, so a test isolates it by mocking `Get-Config`
(`ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES`) — the same seam the function uses.

### Case-sensitive patterns

The precedent is the `-Author` parameter of `Add-SessionLearning` (`Catzc.Base.Docs`), which requires a capitalised person name:

```powershell
# GOOD — the capital the pattern names is required
[ValidatePattern('^[A-Z][a-z]+( [A-Za-z]+){0,3}$', Options = 'None')]
[string] $Author

# BAD — 'jack' passes, because the match ignores case
[ValidatePattern('^[A-Z][a-z]+( [A-Za-z]+){0,3}$')]
[string] $Author
```

An inline `(?-i)` at the start of the pattern does the same inside the pattern itself (`'(?-i)^[a-z0-9]+(-[a-z0-9]+)*$'`, a kebab-case key),
and suits a pattern that carries no other named argument. A pattern that names no case (`^\d+$`), or names both cases in one class
(`[A-Za-z]`), needs neither.

## Decision

The primary argument is positional (`Position = 0`); opt-in behavior is a `[switch]` that is off by default. A configurable parameter
declares the configured value as its default. Secondary inputs are named parameters. A case-sensitive `ValidatePattern` carries
`Options = 'None'` or a leading `(?-i)`.

### How this is enforced

- **The doctrine layer** — what defaults exist and where they come from is [sensible-defaults](../sensible-defaults.md)
  (`ADR-AUTO-DEFAULT`); this record fixes only the parameter mechanics.
- **Custom PSScriptAnalyzer rules** (`pwsh/.scriptanalyzer/ParameterDesign.psm1`) — `Measure-PrimaryArgumentPosition` flags a function whose
  one mandatory parameter lacks `Position = 0` (ADR-PWSH-PARAM-POSITIONALPRIMARY), and `Measure-ParameterFillIn` flags a body that fills an
  empty parameter in (ADR-PWSH-PARAM-RESOLUTIONORDER), and `Measure-CaseSensitivePattern` flags a `ValidatePattern` whose character class or
  `\p{Lu}`/`\p{Ll}` names one case without `Options` or a leading `(?-i)` (ADR-PWSH-PARAM-CASESENSITIVEPATTERN).
- **The exemplars** — the `Invoke-*` family (`Invoke-Executable`, `Invoke-Poetry`, `Invoke-Python`) is the pattern new functions copy.
- **Code review** — a `[bool]` where a `[switch]` belongs, or a pattern whose case dependence the analyzer cannot see (a literal word such
  as `^Get-`), is rejected against this record.

## Consequences

- Call sites read as intent: `Invoke-Poetry 'install' -PassThru` states the action and the one opted-in behavior, nothing else.
- Switch propagation is mechanical (`-DryRun:$DryRun`), so a flag travels a call chain without boolean plumbing.
- The cost is one judgment per function — which parameter is primary — made once by the author instead of on every call.
