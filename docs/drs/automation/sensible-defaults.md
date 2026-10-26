# ADR: Sensible defaults for all parameters

## Rules: ADR-AUTO-DEFAULT

### Rule ADR-AUTO-DEFAULT-ZEROARGUMENTCALL

The zero-argument call must work. If a function can do useful work without input, all parameters have defaults — `Install-Poetry` installs
the locked version, `Test-Automation` runs every tier its location allows (L0–L3 in the working folder, L0–L2 in a snapshot) with detailed
output.

- [Examples](#examples)

### Rule ADR-AUTO-DEFAULT-DEFAULTSFROMCONFIG

Pull defaults from configuration, not hardcoded values. Tool versions, environment names, and other values that change over time come from
config files; the function reads them internally so callers need not update.

- [Where defaults come from](#where-defaults-come-from)

### Rule ADR-AUTO-DEFAULT-MANDATORYWITHOUTDEFAULT

Make parameters mandatory only when no default makes sense. If the function would do something wrong or meaningless without the value, it is
mandatory; if it can derive a right value, derive it.

- [The principle](#the-principle)

### Rule ADR-AUTO-DEFAULT-ONERESOLUTIONORDER

A configurable setting resolves in one fixed order: the caller's explicit value; else the value in the owning module's configuration
(`Get-Config`), which includes the config contributions gathered from Markdown files and, in build mode, a consumer overlay's fragment
merged onto it ([consumer-overlay](consumer-overlay.md#rule-adr-auto-overlay-configfragment)); else the setting's sensible default. The
sensible default is programmed on the setting's config type, as its `Default<Key>` constant, and shown in the module's shipped config file,
and the two agree unless the config's registry entry gives the reason they differ; so an omitted key and a fresh checkout behave
identically, a reader of the file sees the default, and no function restates the value. Every key of a config type has one **posture**:
defaulted (its `Default<Key>` constant), empty-is-valid (an empty list or map is its value when the file states none), or required (the
type's constructor throws, naming the key and where to add it); a function that reads the config adds no literal fallback of its own.

- [Where defaults come from](#where-defaults-come-from)
- [One resolution order](#one-resolution-order)

### Rule ADR-AUTO-DEFAULT-OUTPUTONLYBYADDRESS

A default scope never reaches the `output` track, `out/`. Every action that defaults to everything in its domain — a `Test-*` gate, an
`Assert-*` guard, `Format-Code` and every formatter, test discovery, any walk of the repository — leaves `out/` out of that default, and a
parameter's default never points into it. An action works in `out/` only when its caller names an address there, a file or a folder, and
then it works on what is on disk at that address, since git tracks nothing under `out/`. A tool that keeps its own state in `out/`, such as
a cache or a run's artifacts, writes to an address it names itself.

- [The output track is reached by address only](#the-output-track-is-reached-by-address-only)

## Context

Automation functions should be easy to call. If a function requires five parameters to do the most common thing, nobody will use it — they
will write their own inline version or skip automation entirely. The most common invocation of any function should require zero or minimal
arguments.

PowerShell makes this easy: parameters can have default values, can pull from configuration, and can be positional. But it requires
discipline to design every function with the "just call it" experience in mind.

### Examples

`What sensible defaults look like`

The examples are pseudo-code:

```text
# GOOD — most common case needs zero arguments
Install-Poetry()                    # installs locked version
Install-Poetry(version: "2.2")      # overrides only when needed

# BAD — caller must always specify version
Install-Poetry(version: "2.1")      # no default, mandatory every time
```

```text
# GOOD — the default is the configured value, declared on the parameter; the caller overrides if needed
function Install-Python(version = Get-ToolConfig("Python").version):
    # ...

# BAD — caller must know the version
function Install-Python(version: required):
    # ...
```

How the parameter surface itself is shaped so the common call stays short — the positional primary argument, switches over booleans — is the
language layer, in the pwsh twin.

### The principle

Every function should answer the question: **"What would the caller most likely pass here?"** If there is a single obvious answer, that
answer is the default. If the answer comes from configuration, read it from config. If the answer is "nothing" (the feature is off), the
behavior defaults to off and the caller opts in explicitly.

This does not mean making everything optional. A function that does nothing useful without a specific value should make that parameter
mandatory. `Invoke-Poetry` without arguments would enter an interactive prompt — that is never the right default, so its arguments are
mandatory. The test is: **does a reasonable default exist?** If yes, use it. If no, make it mandatory.

### Where defaults come from

In order of preference:

1. **Configuration files.** Tool versions come from `pwsh/Base.Execution/configs/tools.yml`. Environment settings come from
   `Catzc.Azure/configs/azure.yml`. The function reads config internally — the caller does not need to know where the value lives.

2. **Convention.** Output verbosity defaults to `Detailed`. A test run's top tier defaults to `3`, capped by its location
   ([test-automation](test-automation.md#rule-adr-auto-test-systemtestsatlthree)). These are values that are right 90% of the time.

3. **The environment.** `Get-RepositoryRoot` provides the working root ([never-depend-on-pwd](never-depend-on-pwd.md)).
   `Get-CatzcModuleRoot` provides the module's own folder. The function uses these anchors instead of requiring a path parameter.

4. **Off, for opt-in behavior.** `-PassThru`, `-DryRun`, `-Silent`, `-NoAssert` — these default to off because the common case does not need
   them; the caller opts in explicitly when needed (in pwsh a switch).

### One resolution order

A setting that a team may tune — a line limit, a wrap mode, a tool version — is a configurable setting, and it resolves the same way
everywhere:

1. **The caller's explicit value.** A call that names the value gets that value; nothing overrides an explicit argument.
2. **The owning module's configuration.** Otherwise the value comes from the module's `configs/<name>.yml`, read through `Get-Config`.
3. **The setting's sensible default.** Otherwise — the key is omitted, or the file states nothing for it — the sensible default applies.

The sensible default is programmed on the config type that maps the file (a C# record constructed by `Get-Config`), and the shipped config
file shows the same value, so the code and the asset a reader opens say one thing. An omitted key and a key set to the default therefore
behave identically, a fresh checkout works with no configuration edits, and no function restates the value. Most of the time the two match;
where a shipped file carries a value of its own, such as this repository enabling every customer, its entry in `configs.yml` names the key
under `differs` with one sentence of reason, and `Test-ShippedConfigs` fails any other difference and any reason whose values agree. This is
not a fallback kept for an older shape ([one-living-version](../principles/one-living-version.md)): it is the single declared default of an
optional setting. How a PowerShell parameter expresses steps 1–2 is the language layer, in the pwsh twin.

### The output track is reached by address only

`A default is the domain's source, never its output`

`out/` is a track like the others, the `output` track
([DDR-TRACKTYPE-CLOSEDSETOFTYPES](../design/track-types.md#rule-ddr-tracktype-closedsetoftypes)): git ignores it, and the tools write their
reports, renders, caches and builds there and read them back. What it holds is the result of an action, not the source of one, so a default
that swept it in would check, format or test yesterday's output as if it were today's code, and a gate would fail on a stale report it wrote
itself. So a default scope is the domain's source, and the output track is never part of it. The defaults already keep to that by their
construction: the gates and `Format-Code` work on the files git tracks, the folder walk excludes `out` (`folder-walk.yml`), and the markdown
scope excludes `out/**` (`globs.yml`). What remains is the explicit address: a caller that names a file or a folder under `out/` — a render
to check, a report to read — gets exactly that address, resolved on disk, because there the caller, not a default, chose the output.

## Decision

Every parameter must have a sensible default unless no reasonable default exists. The most common invocation of any function should require
zero or minimal arguments. No default reaches the output track; only an explicit address does.

## Consequences

- Functions are easy to discover and try — just call them with no arguments and see what happens.
- Scripts are concise — only non-default values appear at the call site, making the intent clear.
- Configuration changes propagate automatically — updating a version in `tools.yml` updates every function that reads it, without touching
  call sites.
- New team members can use functions immediately without reading the help to find out what to pass.
