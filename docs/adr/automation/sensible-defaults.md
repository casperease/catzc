# docs/adr/automation/sensible-defaults.md

`ADR: Sensible defaults for all parameters`

## Rules: ADR-AUTO-DEFAULT

### Rule ADR-AUTO-DEFAULT:1

The zero-argument call must work. If a function can do useful work without input, all parameters have defaults — `Install-Poetry` installs
the locked version, `Test-Automation` runs every tier its slot allows (L0–L3 in the working folder, L0–L2 in a snapshot) with detailed
output.

- [What sensible defaults look like](#what-sensible-defaults-look-like)

### Rule ADR-AUTO-DEFAULT:2

Pull defaults from configuration, not hardcoded values. Tool versions, environment names, and other values that change over time come from
config files; the function reads them internally so callers need not update.

- [Where defaults come from](#where-defaults-come-from)

### Rule ADR-AUTO-DEFAULT:5

Make parameters mandatory only when no default makes sense. If the function would do something wrong or meaningless without the value, it is
mandatory; if it can derive a right value, derive it.

- [The principle](#the-principle)

### Rule ADR-AUTO-DEFAULT:6

A configurable setting resolves in one fixed order: the caller's explicit value; else the value in the owning module's configuration
(`Get-Config`); else the setting's sensible default. The sensible default is declared exactly once — on the setting's config type — so an
omitted key and a fresh checkout behave identically and no function restates the value.

- [Where defaults come from](#where-defaults-come-from)
- [One resolution order](#one-resolution-order)

## Context

Automation functions should be easy to call. If a function requires five parameters to do the most common thing, nobody will use it — they
will write their own inline version or skip automation entirely. The most common invocation of any function should require zero or minimal
arguments.

PowerShell makes this easy: parameters can have default values, can pull from configuration, and can be positional. But it requires
discipline to design every function with the "just call it" experience in mind.

### What sensible defaults look like

```powershell
# GOOD — most common case needs zero arguments
Install-Poetry                              # installs locked version
Install-Poetry -Version '2.2'              # overrides only when needed

# BAD — caller must always specify version
Install-Poetry -Version '2.1'              # no default, mandatory every time
```

```powershell
# GOOD — the default is the configured value, declared on the parameter; the caller overrides if needed
function Install-Python {
    param([string] $Version = (Get-ToolConfig -Tool 'Python').Version)
    # ...
}

# BAD — caller must know the version
function Install-Python {
    param([Parameter(Mandatory)] [string] $Version)
    # ...
}
```

How the parameter surface itself is shaped so the common call stays short — the positional primary argument, switches over booleans — is the
language layer, [parameter-design](powershell/parameter-design.md) (`ADR-AUTO-PSPARAM`).

### The principle

Every function should answer the question: **"What would the caller most likely pass here?"** If there is a single obvious answer, that
answer is the default. If the answer comes from configuration, read it from config. If the answer is "nothing" (the feature is off), the
behavior defaults to off and the caller opts in explicitly.

This does not mean making everything optional. A function that does nothing useful without a specific value should make that parameter
mandatory. `Invoke-Poetry` without arguments would enter an interactive prompt — that is never the right default, so `$Arguments` is
mandatory. The test is: **does a reasonable default exist?** If yes, use it. If no, make it mandatory.

### Where defaults come from

In order of preference:

1. **Configuration files.** Tool versions come from `automation/Catzc.Tooling.Core/configs/tools.yml`. Environment settings come from
   `Catzc.Azure/configs/azure.yml`. The function reads config internally — the caller does not need to know where the value lives.

2. **Convention.** Output verbosity defaults to `Detailed`. Test level defaults to `2`. These are values that are right 90% of the time.

3. **The environment.** `$env:RepositoryRoot` provides the repo root. `Get-CatzcModuleRoot` provides the module's own folder. The function
   uses these anchors instead of requiring a path parameter.

4. **Off, for opt-in behavior.** `-PassThru`, `-DryRun`, `-Silent`, `-NoAssert` — these default to off because the common case does not need
   them; the caller opts in explicitly when needed (expressed as a `[switch]` — see [parameter-design](powershell/parameter-design.md)).

### One resolution order

A setting that a team may tune — a line limit, a wrap mode, a tool version — is a configurable setting, and it resolves the same way
everywhere:

1. **The caller's explicit value.** A call that names the value gets that value; nothing overrides an explicit argument.
2. **The owning module's configuration.** Otherwise the value comes from the module's `configs/<name>.yml`, read through `Get-Config`.
3. **The setting's sensible default.** Otherwise — the key is omitted, or the file states nothing for it — the sensible default applies.

The sensible default is declared once, on the config type that maps the file (a C# record constructed by `Get-Config`, see
[module-config-loading](../configuration/module-config-loading.md)). An omitted key and a key set to the default therefore behave
identically, a fresh checkout works with no configuration edits, and no function or second file restates the value. This is not a fallback
kept for an older shape ([one-living-version](../principles/one-living-version.md)): it is the single declared default of an optional
setting. How a PowerShell parameter expresses steps 1–2 is the language layer,
[parameter-design](powershell/parameter-design.md#configurable-parameters) (`ADR-AUTO-PSPARAM#4`).

## Decision

Every parameter must have a sensible default unless no reasonable default exists. The most common invocation of any function should require
zero or minimal arguments.

## Consequences

- Functions are easy to discover and try — just call them with no arguments and see what happens.
- Scripts are concise — only non-default values appear at the call site, making the intent clear.
- Configuration changes propagate automatically — updating a version in `tools.yml` updates every function that reads it, without touching
  call sites.
- New team members can use functions immediately without reading the help to find out what to pass.
