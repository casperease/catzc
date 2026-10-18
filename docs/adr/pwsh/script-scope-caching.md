# ADR: Script-scope caching — the PowerShell layer over caching

## Rules: ADR-PWSH-CACHE

### Rule ADR-PWSH-CACHE:1

A session cache lives in module `$script:` state, which the importer boundary of
[ADR-AUTO-CACHE#6](../automation/caching.md#rule-adr-auto-cache6) maps onto exactly: `$script:` state is established at import and destroyed
on re-import, so "re-run the importer" is the literal and only invalidation.

- [The `$script:` scope](#the-script-scope)

### Rule ADR-PWSH-CACHE:2

Use module-scoped `$script:` variables for the cache — never `$env:` or `$global:`. `$env:` leaks to child processes and is stringly-typed
([environment-variable-mechanics](environment-variable-mechanics.md)); `$global:` survives re-import and couples modules through shared
session state.

- [The `$script:` scope](#the-script-scope)

### Rule ADR-PWSH-CACHE:4

A function probes its cache entry with `$ExecutionContext.SessionState.PSVariable.GetValue('script:<entry>')`, never with a bare
`$script:<entry>` read, and initialises the cache entry when the probe returns `$null`. The `script:` qualifier is required: an unqualified
name falls through to `$global:` when the module's cache entry is unset.

- [Probing an unset cache entry](#probing-an-unset-cache-entry)

### Rule ADR-PWSH-CACHE:5

The compiled-type prebuild of [ADR-AUTO-CACHE#8](../automation/caching.md#rule-adr-auto-cache8) is realised by the bootstrap:
`Import-CSharpTypes` (`Catzc.Internal.Bootstrap.psm1`) computes the key over every module's `types/*.cs` and loads the committed
`Catzc.Types.<hash>.dll` whose name matches, compiling with `Add-Type` only when none does; `Import-TypesAssembly`
(`Catzc.Internal.Types.psm1`) is the one load path, through the per-user shadow copy, for the bootstrap and the `SpellOutIdentifiers`
analyzer rule alike.

- [The compiled-type prebuild](#the-compiled-type-prebuild)

## Context

[caching](../automation/caching.md) fixes the doctrine: static config reads and filesystem-derived information are cached for the session,
keyed by input, lazily, with the importer as the one invalidation knob. This ADR is the PowerShell layer under it — the `$script:` idioms a
cached function is written with.

### The `$script:` scope

```text
Why `$script:` is the cache scope
```

`$script:` state belongs to the module that declares it: it is created when the module imports, invisible to other modules, and discarded
when the importer re-imports — which is precisely the session-cache lifetime `ADR-AUTO-CACHE` requires, with no extra machinery. The
alternatives both violate the doctrine structurally: `$env:` is process-global, inherited by every child process, and stores only strings;
`$global:` outlives a re-import, so a "fresh" session would resume a stale cache, silently breaking the one invalidation contract.

### The idioms

Static read, keyed by resolved path (as in `Get-Config`, through which every config read routes — see
[module-config-loading](../configuration/module-config-loading.md)):

```powershell
function Get-Config {
    param([string] $Config, [string] $Module)

    $entry = Resolve-ConfigEntry -Config $Config -Module $Module   # @{ Name; Module; Path } (discovery seam)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configCache')) {
        $script:configCache = @{}                    # strict-clean probe of a possibly unset cache entry
    }
    if ($script:configCache.ContainsKey($entry.Path)) {
        return $script:configCache[$entry.Path]      # same object every call
    }

    Assert-PathExist $entry.Path
    $config = <parse $entry.Path -Ordered>
    <validate/map in the owner's scope>              # runs once, on the cache miss
    $script:configCache[$entry.Path] = $config
    $script:configCache[$entry.Path]
}
```

Filesystem-derived information, keyed by resolved root (as in `Get-BicepTemplates`):

```powershell
function Get-BicepTemplates {
    $root = Get-BicepTemplatesRoot                                               # the mockable seam (one prod answer)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:bicepTemplatesCache')) {
        $script:bicepTemplatesCache = @{}
    }
    if ($script:bicepTemplatesCache.ContainsKey($root)) {
        return , $script:bicepTemplatesCache[$root]                              # comma preserves array-ness
    }

    $templates = <scan infrastructure/templates, read+validate options.yml, assert short_name uniqueness>
    $script:bicepTemplatesCache[$root] = $templates
    , $script:bicepTemplatesCache[$root]
}
```

(Resetting the whole `$script:bicepTemplatesCache` to `$null` discards every keyed entry, which is the intended hard reset.)

### Probing an unset cache entry

All code runs under `Set-StrictMode -Version Latest` ([error-handling](error-handling.md)), where reading a variable that was never assigned
throws. A cache entry is exactly such a variable on the first call: nothing declares it at import, because a function file holds one
function and no top-level statements ([one-function-per-file](one-function-per-file.md)). The probe therefore asks the session state for the
value instead of reading the variable: `PSVariable.GetValue('script:<entry>')` returns `$null` for an unset cache entry and for a cache
entry a test reset to `$null`, and resolves the module's own `$script:` scope — a same-named function local, caller variable, or `$global:`
never answers for it. Without the `script:` qualifier the lookup walks the scope chain and returns a `$global:` of the same name.

The probe costs a few microseconds per call, a small share of even the hottest cached function (`Get-Config`). The alternatives are worse:

- **A bare read** (`-not $script:x`, `$null -ne $script:x`) and **`$script:x ??= @{}`** read the unset variable and throw under strict mode.
- **`Get-Variable -Scope Script -ValueOnly`** and **`Test-Path variable:script:x`** are correct but cost two to three times the probe, on
  the path every cache hit takes.
- **`try { $script:x } catch { }`** is the cheapest, but it is a catch-and-continue inside a function, which
  [single-responsibility-functions](../automation/single-responsibility-functions.md#rule-adr-auto-onejob5) forbids.

Only the probe changes: once the cache entry is initialised in the same function, the function reads and writes `$script:<entry>` directly.

### Testing cached functions

A warm cache short-circuits before any dependency runs, so mocking a cached function's _internals_ silently tests nothing — the mock never
fires. A test therefore mocks the **whole boundary function** and lets the cache be an implementation detail. The one exception is a test
whose subject _is_ the cache: it resets the module-scope cache entry first
(`InModuleScope Catzc.Base.Config { $script:configCache = $null }`) and pays the cold derive deliberately. Resetting per test everywhere
else defeats the cache and multiplies test-run time (see [test-automation](../automation/test-automation.md)). The mocking rule, with this
one exception, is [ADR-PWSH-PESTER#3](pester-testing.md#rule-adr-pwsh-pester3).

### The compiled-type prebuild

The one cache that outlives a session is the compiled-type assembly, and it lives in no `$script:` variable: the key is its file name. The
bootstrap's `Import-CSharpTypes` hashes the type sources, finds the committed assembly of that name, and loads it, so a fresh checkout never
compiles; a source edit changes the name, and only then does `Add-Type` compile. Loading goes through `Import-TypesAssembly`, which copies
the assembly to a per-user shadow folder first, so no session locks `automation/.compiled`. The compile itself and the stale-types guard are
[hosting-csharp-types](hosting-csharp-types.md).

## Decision

Session caches are module `$script:` hashtables keyed by resolved input, populated on first use, discarded by re-import — never `$env:` or
`$global:` — probed strict-clean through `PSVariable.GetValue('script:<entry>')`, and tests mock the cached function whole, resetting the
cache entry only to exercise cache behavior itself. The compiled-type prebuild is the one cross-session cache, keyed by its file name and
loaded through the shadow copy.

### How this is enforced

- **The exemplars** — `Get-Config` (`Catzc.Base.Config`) and `Get-BicepTemplates` (`Catzc.Azure.Templates`) are the patterns every new
  cached function copies.
- **Custom PSScriptAnalyzer rule `Measure-NoBareCacheEntryRead`** (`automation/.scriptanalyzer/NoBareCacheEntryRead.psm1`) — flags a
  `$script:` read before the function assigns it (ADR-PWSH-CACHE#4).
- **The doctrine layer** — what may be cached at all, and the lazy/eager split, is [caching](../automation/caching.md) (`ADR-AUTO-CACHE`);
  this ADR only fixes the storage idiom.
- **Code review** — a cache in `$env:`/`$global:`, or a test that mocks a cached function's internals, is rejected against this ADR.

## Consequences

- Every cache shares one lifetime story: import populates nothing, first use populates the cache entry, re-import destroys it. There is no
  second invalidation mechanism to reason about.
- Caches are module-private by construction — no cross-module coupling through shared cache state, and parallel test workers cannot see each
  other's cache entries (each process imports its own).
- Tests stay honest: mocking the boundary function works whether the cache is cold or warm, and only deliberate cache tests touch the cache
  entry.
