# docs/adr/automation/internal-asset-dependencies.md

`ADR: Internal asset dependencies — located through one helper, tested in both run modes`

## Rules: ADR-AUTO-ASSETDEP

### Rule ADR-AUTO-ASSETDEP:1

An **internal asset dependency** is any read, by a module's own code, of content that ships inside the code tree: the module's `configs/`
and `assets/`, another module's (a cross-module edge declared in `dependencies.yml`), `.internal/assets/`, `.vendor/`, and `.compiled/`. It
is located only through `Get-CatzcModuleRoot -ChildPath '<literal>'`, or `Get-CatzcModulesRoot` for the dot-prefixed infrastructure — never
through `$PSScriptRoot`, `Get-RepositoryRoot`, or a hand-built `automation/...` path.

- [One helper, one answer in both modes](#one-helper-one-answer-in-both-modes)

### Rule ADR-AUTO-ASSETDEP:2

`-ChildPath` is a string literal at every call site, so the full set of internal asset dependencies — one (module, function, child path)
entry per call site — is derived from the code by `Get-InternalAssetDependency`. The code is the registration; there is no separate list to
keep in step.

- [The code is the inventory](#the-code-is-the-inventory)

### Rule ADR-AUTO-ASSETDEP:3

Every function with an internal asset dependency is covered by at least one test that reads the real asset (the read is not mocked away),
carries the citation tag `ADR-AUTO-ASSETDEP#3`, and is not tagged `source-only`, so it runs in both the source run and the build run.
Because it reads a shipped asset, it is an `integrity` test (ADR-AUTO-TEST#1); the function's logic tests keep using fixtures.

- [A real-asset test that runs in both test runs](#a-real-asset-test-that-runs-in-both-test-runs)

### Rule ADR-AUTO-ASSETDEP:4

The rule is gated mechanically. A coverage gate fails the run when a function listed by `Get-InternalAssetDependency` has no test that
satisfies ADR-AUTO-ASSETDEP#3, naming the function and its uncovered child paths. A build gate fails `Build-Modules` when any listed
(module, child path) is absent from the built output.

- [Two gates: coverage and presence](#two-gates-coverage-and-presence)

### Rule ADR-AUTO-ASSETDEP:5

A new internal asset dependency lands together with its covering test in the same change. Adding the read without the test turns the
coverage gate red, so the omission cannot merge.

- [Two gates: coverage and presence](#two-gates-coverage-and-presence)

## Context

The toolset runs in two modes ([run-modes](../design/run-modes.md), `ADR-DSGN-RUNMODE`): source mode, loading each module from
`automation/<Module>/`, and build mode, loading the same modules from a built package. In source mode a module's code sits next to its
assets, so a lookup anchored on the wrong root often finds the file anyway. The same lookup fails only when the module runs from somewhere
else — the build — which is the mode least exercised while writing the code.

Three anchors give a wrong answer outside the source tree, each in its own way:

- **`$PSScriptRoot`** is the folder of the executing file. In source mode that is the module folder or its `private/` folder; in build mode
  it is the folder of the one merged `<Module>.functions.ps1`. A `'../configs/…'` hop written for a `private/` file points above the module
  in the build.
- **`Get-RepositoryRoot`** is the working root. In source mode the code lives under it; in an install it is the user's working folder, which
  holds no automation at all; and in a build loaded inside the repository it silently reads the source tree instead of the build.
- **A hand-built `automation/<Module>/…` path** bakes the source layout into the code; a build has no `automation/` folder.

Each of these passes every source-mode test and fails in a user's installed session. The defect is invisible exactly where the code is
written and tested, so review and source-mode tests cannot be what catches it.

## Decision

Internal assets are located through one helper whose answer is correct in both modes, every such lookup is visible in the code as a literal
path, and every function that performs one is tested against the real asset in both test runs. Coverage and presence are checked by gates,
not by review.

### One helper, one answer in both modes

`Get-CatzcModuleRoot` returns the calling module's folder under the active code root (`CatzcModulesRoot`) —
`<RepositoryRoot>/automation/<Module>` in source mode, `<build>/<Module>` in build mode — joined with `-ChildPath` when given. The layout
below a module folder (`configs/`, `assets/`, `types/`) is the same in both modes, so one call names the same file in both. The module
defaults to the caller's own; an explicit `-Module` reads another module's content, which is a cross-module dependency and therefore an edge
in `dependencies.yml` ([controlling-module-dependencies](controlling-module-dependencies.md)). The dot-prefixed infrastructure that is not a
module — the `.internal` assets, the vendored modules, the compiled types — is located from `Get-CatzcModulesRoot` directly. The analyzer
rule `Measure-NoScriptRootAnchor` bans `$PSScriptRoot` in module function files
([never-depend-on-pwd](never-depend-on-pwd.md#rule-adr-auto-nopwd5)), which leaves the helper as the only way a function can find its
content.

### The code is the inventory

Because every call passes a literal child path, the dependency set is a pure function of the code: `Get-InternalAssetDependency` walks the
syntax trees of the module function files and returns one `@{ Module; Function; ChildPath; File; Line }` per call site. A computed child
path would hide the dependency from that scan, so the literal is part of the rule. No registry file lists the dependencies — a hand-kept
list would drift from the code it describes, and the code says everything the gates need
([open-closed-architecture](open-closed-architecture.md)).

### A real-asset test that runs in both test runs

A function that reads a shipped asset is covered by a test that lets the read happen: it loads the module, calls the function, and asserts
on what the real asset produced. Mocking the read away would test the mock, which is the one thing that does not change between the modes.
The test reads the shipped file, so it is an `integrity` test, and it is never `source-only`, so the build run executes it against the built
module ([test-automation](test-automation.md#rule-adr-auto-test31)). The citation tag `ADR-AUTO-ASSETDEP#3` is what lets the coverage gate
find it. The function's other behaviour stays in its logic tests, on fixtures, as usual — the real-asset test exists to prove the lookup,
not to re-test the logic.

### Two gates: coverage and presence

The **coverage gate** is an integrity test that runs in both test runs: for every function in the inventory it looks in that function's
`Verb-Noun.Tests.ps1` for a test that cites `ADR-AUTO-ASSETDEP#3` and is not `source-only`, and fails with the function and its uncovered
child paths when there is none. The **build gate** is part of `Build-Modules`' self-check
([platform-bundle](platform-bundle.md#rule-adr-auto-bundle5)): every inventoried (module, child path) must exist in the built output, so a
side folder the build forgot to copy fails the build, not a user's session.

Together they make the rule self-maintaining. A new asset read appears in the inventory the moment it is written; without its covering test
the coverage gate is red, so the change cannot merge ([poka-yoke](../principles/poka-yoke.md)).

### How this is enforced

- **`Get-CatzcModuleRoot`** (`Catzc.Base.Repository`) — the one helper for a module's own content.
- **`Measure-NoScriptRootAnchor`** (`automation/.scriptanalyzer/`) — flags `$PSScriptRoot` in module function files.
- **`Get-InternalAssetDependency`** (`Catzc.Base.ModuleSystem`) — derives the inventory from the code.
- **The coverage gate** — an integrity test over the inventory, in both test runs (ADR-AUTO-ASSETDEP#4).
- **The build gate** — `Build-Modules` / `Assert-CatzcBundle` check every inventoried path in the built output (ADR-AUTO-ASSETDEP#4).
- **`Test-CatzcBuild`** — runs every `ADR-AUTO-ASSETDEP#3` test against the build.

## Consequences

- A lookup that works only in the source tree is caught in CI, by the build run, before it reaches an installed package.
- The full list of what each module reads from the code tree is one command away, always current, and never maintained by hand.
- Every built module carries the content its code reads; a missing side folder fails the build.
- Each asset-reading function carries one more test, an integrity test that reads the real asset — a small, fixed cost per dependency.
- Child paths are literals, so an asset path cannot be assembled at runtime; a function that needs a choice of assets names each one.

## Related

- [run-modes](../design/run-modes.md) — the two modes this rule keeps equivalent.
- [never-depend-on-pwd](never-depend-on-pwd.md) — the code-root anchor and the `$PSScriptRoot` ban.
- [platform-bundle](platform-bundle.md) — the build and its self-check.
- [test-automation](test-automation.md) — logic vs integrity tests, the two test runs, and the `source-only` tag.
- [controlling-module-dependencies](controlling-module-dependencies.md) — the declared edge a cross-module asset read implies.
- [conventional-folders](../repository/conventional-folders.md) — the `configs/` and `assets/` folders the lookups resolve into.
