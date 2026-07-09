# ADR: Sensible defaults for all parameters

## Rules: ADR-AUTO-DEFAULT

### Rule ADR-AUTO-DEFAULT:1

The zero-argument call must work. If a function can do useful work without input, all parameters have defaults — `Install-Poetry` installs
the locked version, `Test-Automation` runs L0 + L1 with normal output.

- [What sensible defaults look like](#what-sensible-defaults-look-like)

### Rule ADR-AUTO-DEFAULT:2

Pull defaults from configuration, not hardcoded values. Tool versions, environment names, and other values that change over time come from
config files; the function reads them internally so callers need not update.

- [Where defaults come from](#where-defaults-come-from)

### Rule ADR-AUTO-DEFAULT:5

Make parameters mandatory only when no default makes sense. If the function would do something wrong or meaningless without the value, it is
mandatory; if it can derive a right value, derive it.

- [The principle](#the-principle)

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
# GOOD — reads from config, caller overrides if needed
function Install-Python {
    param([string] $Version)
    $config = Get-ToolConfig -Tool 'Python'
    if (-not $Version) { $Version = $config.Version }
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
   `Catzc.Azure.Templates/configs/azure.yml`. The function reads config internally — the caller does not need to know where the value lives.

2. **Convention.** Output verbosity defaults to `Normal`. Test level defaults to `1`. These are values that are right 90% of the time.

3. **The environment.** `$env:RepositoryRoot` provides the repo root. `$PSScriptRoot` provides the script's own directory. The function uses
   these anchors instead of requiring a path parameter.

4. **Off, for opt-in behavior.** `-PassThru`, `-DryRun`, `-Silent`, `-NoAssert` — these default to off because the common case does not need
   them; the caller opts in explicitly when needed (expressed as a `[switch]` — see [parameter-design](powershell/parameter-design.md)).

## Decision

Every parameter must have a sensible default unless no reasonable default exists. The most common invocation of any function should require
zero or minimal arguments.

## Consequences

- Functions are easy to discover and try — just call them with no arguments and see what happens.
- Scripts are concise — only non-default values appear at the call site, making the intent clear.
- Configuration changes propagate automatically — updating a version in `tools.yml` updates every function that reads it, without touching
  call sites.
- New team members can use functions immediately without reading the help to find out what to pass.

## Dora explains

Smart defaults pulled from configuration enable self-service platform capabilities and reduce the friction of automation. Functions that
work on zero arguments with sensible behavior lower adoption barriers and speed up iteration.

- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — sensible defaults make the platform self-discoverable and
  reduce the need for elaborate documentation.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — defaults pulled from config reduce call-site noise and
  eliminate scattered magic numbers.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — configuration-driven defaults ensure consistent behavior
  and make version/environment changes propagate uniformly.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
