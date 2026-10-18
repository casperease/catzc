# ADR: The pwsh engine — PowerShell 7 as catzc's module engine

## Rules: ADR-PWSH-ENGINE

### Rule ADR-PWSH-ENGINE:1

pwsh is one of the three execution engines ([execution-engines](../automation/execution-engines.md#rule-adr-auto-engine1)), and the one
every catzc module runs under: PowerShell 7.4 or later, on Windows, Linux, and macOS. `Invoke-Importer` refuses an older PowerShell before
anything loads. A pwsh that catzc starts as an engine is located beside the running PowerShell, `$PSHOME`
([execution-engines](../automation/execution-engines.md#rule-adr-auto-engine3)), so it is the caller's own pwsh, never Windows PowerShell
5.1 and never another pwsh that comes first on `PATH`.

- [One engine of three](#one-engine-of-three)

### Rule ADR-PWSH-ENGINE:2

Every PowerShell scope catzc owns runs under `Set-StrictMode -Version Latest`, the engine's strict mode
([execution-engines](../automation/execution-engines.md#rule-adr-auto-engine2)). Strict mode belongs to a PowerShell scope, and a
session-level setting does not reach module code, so it is set where the code runs: the importer in the caller's scope, `Import-AllModules`
in each module's script scope, the top of each `.internal` module and analyzer rule, a template's `PrePost.psm1` scope after its import, the
first line of a pipeline step that runs without the importer, and the test worker before Pester starts. Code is written strict-clean
([error-handling](error-handling.md#rule-adr-pwsh-error8)).

- [Strict mode](#strict-mode)

### Rule ADR-PWSH-ENGINE:3

The importer sets the session's preferences once, globally: `$global:ErrorActionPreference = 'Stop'`, `$global:WarningPreference = 'Stop'`
(`'Continue'` only under `-AllowWarnings`), and `$global:InformationPreference = 'Continue'`, and it prepends the catzc error view
(`ErrorView.format.ps1xml`). No function changes them. How code throws, warns, and reports under these preferences is
[error-handling](error-handling.md) (ADR-PWSH-ERROR#1, ADR-PWSH-ERROR#2).

- [Session preferences](#session-preferences)

### Rule ADR-PWSH-ENGINE:4

`importer.ps1` is always **dot-sourced** (`. ./importer.ps1`), so it runs in the caller's scope and its session state lands in the caller's
session. It is a generated shim (`New-Importer`) that carries only the importer's parameter block and delegates the whole load sequence to
`Invoke-Importer` in `Catzc.Internal.Importer`, the one living copy, which it removes once the load returns. The state it leaves is fixed:
`$env:RepositoryRoot` (the shim's own folder) and `$env:CatzcModulesRoot`; the preferences and error view of ADR-PWSH-ENGINE#3; UTF-8
console output when output is redirected; the `.internal` modules that stay loaded (`Catzc.Internal.Loader`, `Catzc.Internal.Types`,
`Catzc.Internal.Vendor`); the vendored modules and every catzc module; the session's record of loaded C# types; and the session `PATH`
reconciled to the tools present. Each lasting change is announced
([console-output-matters](../automation/console-output-matters.md#rule-adr-auto-console11)).

- [The dot-sourced importer](#the-dot-sourced-importer)

### Rule ADR-PWSH-ENGINE:5

The build's entry is `Import-Catzc.ps1`, the pwsh mechanics of [platform-bundle](../automation/platform-bundle.md) (ADR-AUTO-BUNDLE#3,
ADR-AUTO-BUNDLE#8). It is authored once, at `automation/.internal/assets/Import-Catzc.ps1`, and copied verbatim into every build; the
build's generated `Catzc.psm1` dot-sources it, so `Import-Module Catzc` and `. <build>/Import-Catzc.ps1` set up the same session. It sets
`$env:RepositoryRoot` (its `-RepositoryRoot`, else the value already set, else the current location) and `$env:CatzcModulesRoot` (its own
folder), then calls `Invoke-Importer -Bundle`, which sets the preferences of ADR-PWSH-ENGINE#3 and registers the prebuilt types and their
accelerators ([hosting-csharp-types](hosting-csharp-types.md#rule-adr-pwsh-types2)) before it reads any module's prebuilt manifest. The root
`importer.ps1` that `Export-Catzc -Root <dir>` writes dot-sources it with `-RepositoryRoot <dir>`.

- [The build's entry](#the-builds-entry)

### Rule ADR-PWSH-ENGINE:6

The Pester workers of a test run, the isolated runs of `Test-InIsolation`, and the snapshot priming of a test run each start a child pwsh,
never an engine from the per-engine loop of [execution-engines](../automation/execution-engines.md#rule-adr-auto-engine4). Pester is a
PowerShell framework, so these starts are pwsh by nature and have no column for any other engine; behaviour that differs between the engines
is proven by the black-box tests and the engine-case tables ([execution-engines](../automation/execution-engines.md#rule-adr-auto-engine5)).

- [Starts that are pwsh by nature](#starts-that-are-pwsh-by-nature)

## Context

[execution-engines](../automation/execution-engines.md) (`ADR-AUTO-ENGINE`) declares the engines, what differs between them, and how each is
located and started. The `automation/` rules say what a function, a test, a cache, or a bundle is, in words that would hold for any engine.
This ADR is the pwsh engine itself: the floor it requires, the session the importer establishes, and the entries that load catzc into it.
The other ADRs of the `pwsh/` folder build on it, each realising one `automation/` rule in PowerShell.

### One engine of three

pwsh is the engine the modules are written for; the POSIX engines reach catzc through `importer.sh` and its `cats` dispatcher, which runs
each command in pwsh. So the engine every command finally runs under is pwsh, and its version decides what the code may use. 7.4 is the
floor because the vendor functions use the bundled `Microsoft.PowerShell.PSResourceGet`, first shipped in 7.4, and because one floor on
every platform keeps one code path ([cross-platform](../automation/cross-platform.md)). The floor is a check at the start of
`Invoke-Importer`, before any module or type loads, so an older PowerShell fails with one clear message instead of with a parse error deep
in a module.

A started pwsh comes from `$PSHOME` for the reason the engine model gives: the PowerShell that runs the caller is the one the caller tested
against, and the first `pwsh` on `PATH` may be an older or a second install.

### Strict mode

Strict mode catches the mistakes PowerShell otherwise lets pass: a variable never assigned, a property an object does not carry, an index
out of range. It is a property of a PowerShell scope. A module's functions run in the module's script scope, not the caller's, so a
`Set-StrictMode` at the prompt never reaches them. catzc therefore sets strict mode in each scope it owns, at the point where that scope
starts, and it holds in the source tree and an installed build alike, because the build loads through the same importer. Code that must
probe non-strict behaviour opts out locally, in the one test body that needs it ([pester-testing](pester-testing.md)).

### Session preferences

catzc functions are written for terminating failure: an error stops the call, and a warning is a failure that has not been diagnosed yet.
PowerShell's defaults let a non-terminating error or a warning pass, so the code would have to guard every call. The importer instead sets
the preferences once for the whole session, which makes every catzc function and every vendored command fail the same way. Setting them
inside a function would make the function's behaviour depend on its caller, so no function does. `-AllowWarnings` exists for a session that
must load past a third-party warning; it is the importer's switch, not a function's.

### The dot-sourced importer

Dot-sourcing runs a script in the caller's scope. The importer's job is to change the caller's session — its strict mode, its preferences,
its roots, its modules — so it is dot-sourced, and calling it any other way leaves part of that state in a scope that ends with the call.
Dot-sourcing at the prompt also tells the importer that a person is at the console, which decides whether it times the load and whether a
stale-types import continues in a new pwsh.

The shim is generated and thin so that the load sequence has one living copy, `Invoke-Importer`
([one-living-version](../principles/one-living-version.md)). `importer.ps1` is a root file that a fresh clone needs, so it is committed and
reproduced by `Build-RootConfig`; its parameter block is asserted to match `Invoke-Importer`'s. Removing `Catzc.Internal.Importer` after the
load keeps import-time orchestration out of the session, while the `.internal` modules that the loaded functions delegate to stay.

### The build's entry

A build has no repository to anchor on, so its entry sets both roots before the importer runs: the working root where the caller says, and
the code root where the build is. Everything after that is the one importer in its bundle mode, so a build loads in the same order, under
the same preferences, as the source tree. The order matters in pwsh: a type accelerator named in a parameter constraint must be registered
before the module that names it loads, which is why the bundle reuses the importer rather than listing every module as a nested module of
one manifest.

`Import-Module Catzc` and dot-sourcing `Import-Catzc.ps1` are the two ways a pwsh user reaches a build. The generated `Catzc.psm1` holds one
line that dot-sources the entry, so both ways run the same file and there is no second loader.

### Starts that are pwsh by nature

A test run shards its Pester files over worker processes, `Test-InIsolation` runs a module's tests in a clean child process, and a test run
primes a repository snapshot by importing it once. Each of these starts pwsh because what it runs is PowerShell: Pester, or the importer
itself. They are not engine-neutral starts with a pwsh default, so they do not take the engine start environment, and running them under
another engine would mean nothing. The per-engine runs belong to the black-box tests, whose command text is the same under every engine.

## Decision

catzc runs its modules under PowerShell 7.4 or later, with strict mode in every scope it owns and terminating preferences set once for the
session. The source tree loads by dot-sourcing the generated `importer.ps1`, a build by `Import-Catzc.ps1` or `Import-Module Catzc`, and
both run the one `Invoke-Importer`. The starts that run Pester or the importer are pwsh starts, outside the per-engine loop.

### How this is enforced

- **`Invoke-Importer`** (`Catzc.Internal.Importer`) — the version floor, the session preferences and error view, the two roots, and the load
  sequence, in both run modes.
- **`Import-AllModules`** (`Catzc.Internal.Bootstrap`) — sets strict mode in each imported module's script scope.
- **`New-Importer`** and **`Build-RootConfig`** — generate `importer.ps1` from the importer's parameter block; `Test-GeneratedFiles` reports
  drift.
- **`Invoke-ModuleBuild`** (`Catzc.Internal.Builder`) — copies `Import-Catzc.ps1` into every build and writes the one-line `Catzc.psm1`.
- **`Resolve-EngineExecutable`** — locates pwsh beside `$PSHOME` for every engine start.

## Consequences

- Every catzc session, from the source tree or a build, has the same strict mode and the same terminating preferences, so a function behaves
  the same wherever it is loaded.
- A caller that runs `importer.ps1` without dot-sourcing it does not get the session it expects, so the dot-sourced form is the only one the
  documentation shows.
- An older PowerShell fails at the first line of the load with the floor it needs, never partway through.
- Pester and the importer stay pwsh-only; the cost of proving engine-neutral behaviour falls on the black-box tests, which run once per
  engine.

## Related

- [execution-engines](../automation/execution-engines.md) — the engines, their model, and how each is located and started.
- [platform-bundle](../automation/platform-bundle.md) — the bundle whose pwsh entry ADR-PWSH-ENGINE#5 describes.
- [run-modes](../design/run-modes.md) — the source and build modes the two entries load.
- [error-handling](error-handling.md) — how code throws and warns under the session preferences.
- [dynamic-module-manifests](dynamic-module-manifests.md) — the manifests the importer generates in source mode and reads in a build.
