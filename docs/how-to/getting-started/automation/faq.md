# FAQ

## But if we import all the functions all the time, won't we waste time?

No. Loading is fast because PowerShell only _parses_ the function definitions at import time — it does not _execute_ them. The cost of
parsing a `.ps1` file with a single function is negligible (sub-millisecond).

The bootstrap module generates a `.psd1` manifest per module and lists every `.ps1` file in `NestedModules`. PowerShell's module loader
handles this natively — no dot-sourcing loop, no custom loader. Vendor modules that are expensive to load (Pester, PSScriptAnalyzer) are
deferred via the `Lazy` parameter and only imported on first use.

In practice the entire import completes in under a second. You would need hundreds of modules before parsing overhead became measurable, and
at that point the bottleneck would be disk I/O, not the function count.

## But if we don't specifically declare dependencies, won't we have dependency hell?

No. Dependency hell comes from _independently versioned and deployed_ packages that must resolve compatible version ranges at install time.
That problem does not exist here because:

1. **Everything loads together.** `importer.ps1` loads all modules into global scope in a single pass. Every function is available
   everywhere after import — there is nothing to resolve.

2. **Load order is deterministic.** Vendor modules load first, then private files before public files within each module. A function can
   call any other function that was defined before or alongside it.

3. **Missing dependencies fail immediately.** If a function calls something that does not exist, PowerShell throws a clear error the moment
   the call is made. There is no silent fallback or version mismatch — it either works or it tells you what is missing.

4. **One repo, one version.** All code lives in the same repository and moves forward together. There are no version ranges, no lock files,
   and no transitive dependency graphs to reconcile.

Explicit dependency declarations add value when packages are published and consumed independently. In a monorepo where everything is loaded
as a unit, they add ceremony without benefit.

## Why is this better than just having .ps1 files across the repo, where each script loads the other scripts it needs?

That pattern — scripts dot-sourcing their own dependencies — works for small projects but breaks down quickly:

- **Fragile paths.** Every script must know the relative path to every script it depends on. Move a file and every consumer breaks. Add an
  indirect dependency and every intermediate script must forward it.

- **Duplicate loading.** If `A.ps1` sources `C.ps1` and `B.ps1` also sources `C.ps1`, the file is parsed and executed twice. With deep
  dependency trees this multiplies. There is no built-in deduplication.

- **No scope isolation.** Dot-sourcing runs in the caller's scope. A helper that sets `$ErrorActionPreference` or defines a variable with a
  common name silently bleeds into every consumer. Bugs caused by this are hard to trace.

- **No discoverability.** There is no single place that tells you what functions exist or which script provides them. You have to grep for
  dot-source lines and chase the chain.

The module system solves all of these. `importer.ps1` is the single entry point — one line to load everything. Functions live in module
scope so they cannot pollute the caller. PowerShell's module loader deduplicates automatically. File moves require no consumer changes
because the bootstrap module discovers files by convention, not by hardcoded path. The result is the simplicity of flat scripts with the
safety of proper modules.

## Is importing everything via importer.ps1 really as effective as dot-sourcing only the functions a script uses?

Yes — and in practice it is _more_ effective, not less.

**Parse cost is near-zero.** PowerShell parses a function definition in sub-millisecond time. Loading 100 extra functions you don't call
adds roughly 50–100 ms total. You will not notice this.

**Execution cost is zero.** Functions that are never called consume no CPU and no meaningful memory. A parsed function definition is just an
AST node sitting idle — it is not evaluated, allocated, or warmed up until you invoke it.

**Selective dot-sourcing costs more than you save.** Every `. ./path.ps1` call has overhead: path resolution, file I/O, scope setup. A
script that dot-sources 10 files pays that cost 10 times, and gains nothing over a single `Import-Module` that loads them all at once
through `NestedModules`. The module loader is optimized for batch loading — individual dot-sourcing is not.

**The real cost is maintenance.** The selective approach means every script must track its own dependency list. Add a function call and you
must remember to add the dot-source. Remove one and you leave dead imports. Rename a file and every consumer breaks. These are not
hypothetical problems — they are the daily tax of manual dependency management.

The importer loads everything once, up front, in under a second. After that your script is just logic — no boilerplate, no path management,
no possibility of a missing import at runtime.

## "Trust me, it's simple" isn't enough — what is actually under the hood?

**Fair.** There is real complexity; it is just kept out of your way. Under the covers the system manages several kinds of dependency:

- **Compiled internal types** — immutable, optimized `Catzc.*` types and their processing in the automation layer.
- **Module dependencies** — the internal and vendored modules the automation layer loads.
- **External system dependencies** — the tooling the system shells out to, plus direct OS-level integration for processing and control.
- **Build-time dependencies** — everything the infrastructure build, deploy, and test steps pull in.

All of it is abstracted behind defined runtime conditions and a strict KISS rule, so from the outside the system stays simple. To actually
understand the machinery, read the reference documentation on the automation system.

From a user's seat, though, you rarely touch any of this. Your job is mostly editing configuration, writing regression tests, and adding
templates — the importer and the module loader handle the rest.
