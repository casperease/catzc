# ADR: Caching — static reads and filesystem-derived information (the importer is the cache boundary)

## Rules: ADR-CACHE

### Rule ADR-CACHE:1

Cache static config reads: a function that loads + parses (+ validates) a checked-in file returns the parsed object from a session cache on
repeat calls.

Exemplar: `Get-Config` — every config read routes through it, keyed on the resolved file path in `$script:configCache`, so every config
inherits one cache (see [module-config-loading](module-config-loading.md)).

- [The idioms](#the-idioms)

### Rule ADR-CACHE:2

Cache filesystem-derived information: a function that scans the repo and derives a convention-based result computes it once and returns the
stored result thereafter. Exemplar: `Get-BicepTemplates`.

- [The cost of not caching](#the-cost-of-not-caching)

### Rule ADR-CACHE:4

Key the cache by the function's inputs: no parameters → a single slot; parameters → a cache keyed on them; a resolved-input function keys
on that input. Keys must be session-stable values, never mutable objects.

- [The storage idiom is the language layer](#the-storage-idiom-is-the-language-layer)

### Rule ADR-CACHE:5

Cached values are read-only to callers — a cached function returns the same object reference every call, so callers must treat it as
immutable. A result intended to be mutated downstream is not a caching candidate.

- [What is NOT cacheable](#what-is-not-cacheable)

### Rule ADR-CACHE:6

The only invalidation is re-running the importer — no mtime/hash checks, TTLs, file watchers, or `-Refresh` switch. The runtime contract
makes the importer the single sufficient knob.

- [The importer is the cache boundary](#the-importer-is-the-cache-boundary)
- [Two runtimes fix the file set](#two-runtimes-fix-the-file-set)

### Rule ADR-CACHE:7

Lazy cache-on-first-use is the default; eager compute-at-import is reserved for the bootstrap module alone. A cached function populates its
slot on first call, never at import, because importer time is a protected budget.

- [Importer run time is a protected budget](#importer-run-time-is-a-protected-budget)

### Rule ADR-CACHE:8

The compiled-type prebuild is the one committed, cross-session cache: `Import-CSharpTypes` keys one committed
`automation/.compiled/Catzc.Types.<hash>.dll` for the whole repository (the combined hash of every module's sources), loaded without Roslyn
on a fresh checkout and self-invalidating on any source change. See [native-csharp-types](BCL/native-csharp-types.md) for the full contract.

- [What is NOT cacheable](#what-is-not-cacheable)

## Context

The platform repeatedly performs two kinds of work that are **expensive to redo and deterministic given the files on disk**:

1. **Static file reads.** Loading, parsing, and validating a checked-in config file into an in-memory object — `configs/azure.yml`,
   `configs/tools.yml`, and the like. The result is a pure function of the file's bytes.

2. **[Azure|other].** _The result of scanning the on-disk file set and deriving Information and Meaning from it by convention._ This is the
   platform's convention-handling: which folders are modules, which `.ps1` files are public vs `private/`, which folders under
   `infrastructure/templates/` are templates, what slots and `options.yml` values they declare, whether `short_name`s are unique, the
   env-`code` → env-name map. `Information` here is a pure function of the on-disk file set (plus the static configs it reads — see
   [conventional-folders](../repository/conventional-folders.md)).

Both are deterministic functions of the repository's files.

### Two runtimes fix the file set

The automation runs in exactly two contexts, and both make the on-disk file set **immutable for the lifetime of a session**:

- **Pipeline.** The agent checks out a static, immutable tree and runs `importer.ps1` once at the start. Files never change during the run.
- **Devbox.** A developer dot-sources `importer.ps1` to establish a session. The standing convention is: **re-run the importer after
  changing files on disk.** The importer invocation is the moment the session's view of the repository is fixed.

In both runtimes the **importer invocation is the boundary** at which the file set becomes the session's truth. Nothing the automation
should react to changes the file set mid-session.

### The importer is the cache boundary

It follows that **anything derived from the on-disk file set may be memoized for the lifetime of the session**, and the single, sufficient
way to invalidate is to **re-run the importer** — which starts a fresh process (pipeline) or re-imports the modules (devbox), discarding all
module-scoped `$script:` state. There is no need for timestamp checks, file watchers, or TTLs; the runtime contract already guarantees the
inputs are stable, and the importer is the one knob.

### Importer run time is a protected budget

The importer is on the hot path of **every** session — every interactive shell tab a developer opens and every step a pipeline runs begins
by dot-sourcing it. Its job is to make the module system available, fast, and nothing more: it sets error preferences and runs the bootstrap
module to discover and import modules. It even **defers** expensive vendor modules (Pester, PSScriptAnalyzer) via lazy loading rather than
pay for them at startup (see [vendor-toolset-dependencies](powershell/vendor-toolset-dependencies.md#rule-adr-vendor5)), and it reports its
own load time so regressions are visible.

This makes importer time a budget to protect, and it sets the default for caching: **lazy.** Reading `azure.yml`, scanning
`infrastructure/templates/`, or deriving any other config/information at import would tax every session for work most sessions never use.
Such work is therefore done **on first use** and cached for the rest of the session — paid once, by the sessions that actually need it, not
by all of them. The one thing that is unavoidably eager is the bootstrap module's own module discovery, because without it there are no
functions to call.

### The cost of not caching

`Get-BicepTemplates` is the canonical case: without caching it would rescan `infrastructure/templates/`, read **and re-validate every
`options.yml`**, and re-check `short_name` global uniqueness **on every call**. A single `Deploy-Bicep` triggers it many times over: the
`-Template` `ValidateScript`, `Get-BicepTemplate`, `Get-BicepDeploymentContext`, `Get-BicepTemplateConfiguration`,
`Get-BicepDeploymentName`, `Get-BicepResourceGroupName`, and the completers — easily 8–10 full filesystem rescans producing an identical
result. This is pure [waste](../principles/reduce-waste.md), and on enterprise machines where `$HOME`/repos can sit on network storage it is
also latency that compounds (see [effective-in-enterprises](effective-in-enterprises.md)).

Config caching is centralized in `Get-Config`, which caches every config read lazily in `$script:configCache` keyed on the resolved file
path (so every config read inherits one cache); `Get-BicepTemplates` caches filesystem information per resolved root in
`$script:bicepTemplatesCache`; and the bootstrap module computes module information once at import (eagerly, because it must — see the rule
below). Computing-once applies to all filesystem-derived information; the default is **lazy** so the importer stays fast.

### What is NOT cacheable

The rule has a sharp boundary. Do **not** cache:

- **Runtime / mutable state.** Anything not derived from the static repo: `az account show`, access tokens, deployment outputs, the current
  subscription context. These change _within_ a run, so a cached value would be wrong. (See
  [dual-authentication](../pipelines/dual-authentication.md#rule-adr-auth7): tokens are acquired fresh per call, never cached.)
- **Objects that callers mutate.** The per-slot parameter set returned by `Get-BicepTemplateConfiguration` is read fresh per build and then
  **mutated** by the `Invoke-BicepPrepareParameterSet` merge hook (which writes resolved values into `ParametersFile.parameters`). Caching a
  caller-mutated object would leak one build's mutations into the next. It is also cheap (one small file per slot per build), so it stays
  uncached.
- **Side-effecting / output functions.** `Uninstall-*`, `Install-*`, `Deploy-*` — they do work, they do not return a reusable derivation.

## Decision

Cache, for the lifetime of the session, the results of (a) **static config-file reads** and (b) **filesystem-scan-derived information**.
Store the cache in module state per the language layer ([script-scope-caching](powershell/script-scope-caching.md)). Invalidate only by
re-running the importer. Never cache runtime state or objects callers mutate.

### The storage idiom is the language layer

Where a cache lives, the keyed-hashtable code shape, and how tests interact with a cached function are the PowerShell layer,
[script-scope-caching](powershell/script-scope-caching.md) (`ADR-PSCACHE`): module `$script:` state — never `$env:` or `$global:` — with
`Get-Config` and `Get-BicepTemplates` as the exemplars. The compiled-type prebuild's own cache-key and staleness-guard rules live with the
type system, [native-csharp-types](BCL/native-csharp-types.md) (`ADR-TYPES`).

### How this is enforced

- **`importer.ps1`** rebuilds the session from scratch — a fresh process or a re-import that discards module `$script:` state. This makes
  "re-run the importer" the literal and only invalidation path.
- **The exemplars** (`Get-Config` and `Get-BicepTemplates`) are the patterns new cached functions copy.
- **Code review.** Whether a function's result is a pure derivation of the static file set (cacheable) or runtime/mutable state (not) is a
  review judgment, guided by the "What is NOT cacheable" boundary above.

## Consequences

- Repeated information and config reads cost one scan/parse **per session**, not per call. A `Deploy-Bicep` invocation derives the template
  descriptor once per session, however many callers request it.
- Results are deterministic and self-consistent within a session: every caller sees the same descriptor, because they share one cached
  derivation of one file set.
- Invalidation is trivial and uniform across both runtimes: re-run the importer. There is exactly one knob, and it is the same action a
  developer already takes after editing files.
- The accepted cost: a developer who edits files **without** re-importing sees stale information. This is the documented contract, not a bug
  — the importer is the boundary by design.
- Tests inject the descriptor by mocking the cached function itself (already the established pattern), and reset the `$script:` slot only
  when exercising cache behavior directly.
