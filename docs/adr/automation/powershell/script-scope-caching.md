# ADR: Script-scope caching — the PowerShell layer over caching

## Rules: ADR-PSCACHE

### Rule ADR-PSCACHE:1

A session cache lives in module `$script:` state, which the [caching](../caching.md) (`ADR-CACHE`) boundary maps onto exactly: `$script:`
state is established at import and destroyed on re-import, so "re-run the importer" is the literal and only invalidation.

- [Why `$script:` is the cache scope](#why-script-is-the-cache-scope)

### Rule ADR-PSCACHE:2

Use module-scoped `$script:` variables for the cache — never `$env:` or `$global:`. `$env:` leaks to child processes and is stringly-typed
([environment-variable-mechanics](environment-variable-mechanics.md)); `$global:` survives re-import and couples modules through shared
session state.

- [Why `$script:` is the cache scope](#why-script-is-the-cache-scope)

### Rule ADR-PSCACHE:3

Tests vary cached behavior by mocking the whole function (`Mock Get-BicepTemplates`), not its internals — a warm cache ignores mocked
dependencies. A test exercising cache population resets the slot in module scope (`InModuleScope <Module> { $script:<slot> = $null }`), and
only such a test does.

- [Testing cached functions](#testing-cached-functions)

## Context

[caching](../caching.md) fixes the doctrine: static config reads and filesystem-derived information are cached for the session, keyed by
input, lazily, with the importer as the one invalidation knob. This ADR is the PowerShell layer under it — the `$script:` idioms a cached
function is written with.

### Why `$script:` is the cache scope

`$script:` state belongs to the module that declares it: it is created when the module imports, invisible to other modules, and discarded
when the importer re-imports — which is precisely the session-cache lifetime `ADR-CACHE` requires, with no extra machinery. The alternatives
both violate the doctrine structurally: `$env:` is process-global, inherited by every child process, and stores only strings; `$global:`
outlives a re-import, so a "fresh" session would resume a stale cache, silently breaking the one invalidation contract.

### The idioms

Static read, keyed by resolved path (as in `Get-Config`, through which every config read routes — see
[module-config-loading](../module-config-loading.md)):

```powershell
function Get-Config {
    param([string] $Config, [string] $Module)

    $entry = Resolve-ConfigEntry -Config $Config -Module $Module   # @{ Name; Module; Path } (discovery seam)
    if (-not $script:configCache) { $script:configCache = @{} }
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
    if (-not $script:bicepTemplatesCache) { $script:bicepTemplatesCache = @{} }
    if ($script:bicepTemplatesCache.ContainsKey($root)) {
        return , $script:bicepTemplatesCache[$root]                              # comma preserves array-ness
    }

    $templates = <scan infrastructure/templates, read+validate options.yml, assert short_name uniqueness>
    $script:bicepTemplatesCache[$root] = $templates
    , $script:bicepTemplatesCache[$root]
}
```

(Resetting the whole `$script:bicepTemplatesCache` to `$null` discards every keyed entry, which is the intended hard reset.)

### Testing cached functions

A warm cache short-circuits before any dependency runs, so mocking a cached function's _internals_ silently tests nothing — the mock never
fires. A test therefore mocks the **whole boundary function** and lets the cache be an implementation detail. The one exception is a test
whose subject _is_ the cache: it resets the module-scope slot first (`InModuleScope Catzc.Base.Config { $script:configCache = $null }`) and
pays the cold derive deliberately. Resetting per test everywhere else defeats the cache and multiplies suite time (see
[test-automation](../test-automation.md)).

## Decision

Session caches are module `$script:` hashtables keyed by resolved input, populated on first use, discarded by re-import — never `$env:` or
`$global:` — and tests mock the cached function whole, resetting the slot only to exercise cache behavior itself.

### How this is enforced

- **The exemplars** — `Get-Config` (`Catzc.Base.Config`) and `Get-BicepTemplates` (`Catzc.Azure.Templates`) are the patterns every new
  cached function copies.
- **The doctrine layer** — what may be cached at all, and the lazy/eager split, is [caching](../caching.md) (`ADR-CACHE`); this ADR only
  fixes the storage idiom.
- **Code review** — a cache in `$env:`/`$global:`, or a test that mocks a cached function's internals, is rejected against this ADR.

## Consequences

- Every cache shares one lifetime story: import populates nothing, first use populates the slot, re-import destroys it. There is no second
  invalidation mechanism to reason about.
- Caches are module-private by construction — no cross-module coupling through shared cache state, and parallel test workers cannot see each
  other's slots (each process imports its own).
- Tests stay honest: mocking the boundary function works whether the cache is cold or warm, and only deliberate cache tests touch the slot.
