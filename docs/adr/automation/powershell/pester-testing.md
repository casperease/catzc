# ADR: Pester testing — the language layer over test-automation

## Rules: ADR-PESTER

### Rule ADR-PESTER:1

Pester is the test framework, and a test applies the [test-automation](../test-automation.md) (`ADR-TEST`) doctrine — logic isolated through
seams, integrity bound to the real files — with the mock idioms and file conventions below.

- [The idioms](#the-idioms)

### Rule ADR-PESTER:2

Isolate logic tests through the seams — in `BeforeEach`, mock `Get-BicepTemplatesRoot` to a fixture template tree, and isolate config either
by mocking the discovery seam `Resolve-ConfigEntry` (return a fixture `@{ Name; Module; Path }`) or by mocking `Get-Config` itself.
Redirecting only the template tree leaks the shipped identities back in.

- [The idioms](#the-idioms)

### Rule ADR-PESTER:3

Mock at module boundaries with `-ModuleName`, and mock the whole boundary function — never its internals. A cached function ignores mocked
dependencies ([script-scope-caching](script-scope-caching.md)), and reaching into internals couples the test to implementation.

- [The idioms](#the-idioms)

### Rule ADR-PESTER:4

Test private functions through the module (`& (Get-Module …) { … }` or `InModuleScope`), injecting metadata by mocking the public seam —
never by editing module-scope state except to reset a cache slot.

- [The idioms](#the-idioms)

### Rule ADR-PESTER:5

One test file per function, `Verb-Noun.Tests.ps1` — `Test-Automation.Tests.ps1` enforces the hyphenated basename. A cross-cutting suite is
named after the function it most exercises plus a suffix. A test for a native C# type is named for the type and lives in `tests/types/`
(`<TypeName>.Tests.ps1`) — exempt from Verb-Noun, but the gate requires the name to match a `types/*.cs` in the same module.

- [How this is enforced](#how-this-is-enforced)

## Context

[test-automation](../test-automation.md) fixes the doctrine: what a test may depend on (logic vs integrity), the L0–L3 tiers, the mandatory
tag axes, and the push-left economics. This ADR is the Pester layer under it — the concrete mock idioms a hermetic logic test is written
with, the test-file conventions, and the engine gotchas that repeatedly bite.

## Decision

A logic test mocks the seams (`Get-BicepTemplatesRoot`; `Resolve-ConfigEntry` or `Get-Config`) at module boundaries with `-ModuleName`,
whole functions only; privates are tested through the module; and every test file follows the `Verb-Noun.Tests.ps1` convention.

### The idioms

A hermetic logic test (both seams isolated, fixture identities):

```powershell
Describe 'Get-AzureEnvironment' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-BicepTemplatesRoot { Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates' } -ModuleName Catzc.Azure.Templates
        # Redirect the 'azure' config to the fixture file via the discovery seam.
        Mock Resolve-ConfigEntry {
            @{ Name = 'azure'; Module = 'Catzc.Azure.Templates'
               Path = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/config/azure.yml' }
        } -ParameterFilter { $Config -eq 'azure' } -ModuleName Catzc.Base.Config
    }
    It 'resolves the environment identity against a named subscription' {
        (Get-AzureEnvironment alpha -Subscription core_lower).subscription.name | Should -Be 'core_lower'   # fixture identity, not 'dev'
    }
}
```

The integrity test (binds to shipped assets — mocks nothing):

```powershell
Describe 'Shipped asset integrity' -Tag 'L1', 'integrity' {
    It 'every shipped template references only defined environments and customers' {
        $azure = Get-Config -Config azure
        foreach ($t in (Get-BicepTemplates)) {
            foreach ($slot in $t.slots) {
                $slot.environment | Should -BeIn @($azure.environments.Keys)
            }
        }
    }
}
```

A CLI-tool integration test (L2 — drives `az bicep build`), tagged and self-skipping:

```powershell
Describe 'sample (real az)' -Tag 'L2', 'logic' {
    It 'compiles with az bicep build' {
        if (-not (Get-Command az -ErrorAction Ignore)) { Set-ItResult -Skipped -Because 'tool_az_missing'; return }
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $outputRoot 'main.json' | Should -Exist
    }
}
```

### Gotchas

- **`<word>` in an `It` name is Pester data-binding**, not literal text — `'names parameters.<config>.json'` makes Pester look for
  `$config`. Keep angle brackets out of test names.
- **An unbound `[string]` parameter is `''`, not `$null`** — the engine coerces `$null`→`''` for `[string]`, so `$Customer -eq $null` is
  never true for a `[string]` param. Test emptiness with `if (-not $Customer)` or `[string]::IsNullOrEmpty($Customer)`, and never default
  one with `??` (the default won't apply — see [automatic-variable-pitfalls](automatic-variable-pitfalls.md#rule-adr-autovar6)).
- **`Where-Object prop -EQ` / `ForEach-Object prop` shortcuts do not bind `[ordered]` dictionary keys** — use the script-block form. This
  codebase returns ordered dicts pervasively.
- **A comma-wrapped array return piped directly member-enumerates.** `Get-BicepTemplates | Where …` feeds the whole array as one object;
  parenthesise first: `(Get-BicepTemplates) | Where …`.
- **To test that a parameter is mandatory, bind it to `$null` — never omit it.** An _absent_ mandatory parameter makes an interactive host
  **prompt** (and hang), not throw; it only throws under `-NonInteractive`. Supplying the param explicitly as `$null` (with valid values for
  the others) rejects at binding in _every_ host — `{ Invoke-Foo -X $null -Y @{} } | Should -Throw`. Relying on `-NonInteractive` to turn
  the prompt into a throw masks the hazard rather than removing it, so a `Test-Automation` run from a devbox shell hangs.
- **A reused-and-deleted sandbox path races an on-access file scanner.** A `BeforeEach` that deletes and recreates one fixed sandbox dir
  intermittently throws "… being used by another process" on the delete, because a Windows AV / indexer briefly holds a just-copied file
  open. Do not retry the delete (see [retry-as-last-resort](../retry-as-last-resort.md#rule-adr-retry2)) — remove the need: give each test a
  unique dir, `$script:sandbox = Join-Path $TestDrive ([Guid]::NewGuid())`, copy fixtures in, and drop the cleanup entirely. Pester
  auto-cleans `$TestDrive`, and a unique dir is never re-deleted mid-run. Scratch belongs in `$TestDrive` / `[IO.Path]::GetTempPath()`, not
  `out/` (see [dedicated-output-directory](../../repository/dedicated-output-directory.md#rule-adr-outdir3)).
- **Bulk deletes: use .NET, not per-item `Remove-Item`.** Clearing many entries with per-item `Remove-Item` is ~50× slower than
  `[IO.File]::Delete` / `[IO.Directory]::Delete($d, $true)` (measured ~33 s vs ~0.6 s for ~4,300 entries) — `Clear-TempFolders`
  (`Catzc.Tooling.Provisioning`) uses the .NET calls for this reason. And do not blame AV for temp slowness without checking: a bloated
  `%TEMP%` (tens of thousands of entries) slows NTFS directory creation, and `%TEMP%` is often already AV-excluded while the repo is not.
- **Chained mock state hits a Pester `$script:` scope surprise.** A `Set-` mock that writes `$script:x` and a `Get-` mock that reads it back
  do not reliably round-trip within one test (the mock bodies don't share the scope you expect). Don't assert idempotency by mutating fake
  state and reading it back — assert on the boundary instead: seed the "already present" state and assert `Should -Invoke <writer> -Times 0`
  (it must not have written). Single-direction reads/writes (seed → act → read the writer's captured `$Value`) are fine.
- **Cold-import isolation belongs in a child process, not an in-process runspace.** A fresh runspace looks like cheap isolation, but env
  vars are process-global — the importer's `$env:RepositoryRoot`/`$env:PSModulePath` writes leak into the parent (breaking the real
  session's lazy Pester/PSScriptAnalyzer resolution) — and a loaded assembly cannot be unloaded, so the sandbox's `powershell-yaml` DLL
  stays locked and cleanup fails. `Import-AllModules.Tests.ps1` runs each import in a child `pwsh` for exactly this isolation; reserve
  runspaces for work that writes no process-global state.

### How this is enforced

- **The seams exist** as mockable functions (`Get-BicepTemplatesRoot` for the template tree; `Resolve-ConfigEntry` and `Get-Config` for
  config), so isolation is a mock away and production has a single pristine default. For config, mock the discovery seam to return a fixture
  `@{ Name; Module; Path }`, or mock `Get-Config` outright — the whole function, never its internals (`ADR-PESTER:3`). When exercising cache
  behavior directly, reset the slot per [script-scope-caching](script-scope-caching.md) (`ADR-PSCACHE:3`).
- **`Test-Automation.Tests.ps1`** validates the `Verb-Noun.Tests.ps1` filename convention — a type test under `tests/types/` is instead
  named for the `types/*.cs` it covers — and the one-function-per-file rules for source (see
  [one-function-per-file](one-function-per-file.md)).
- **Code review** checks a new test mocks the right boundaries — not too few, not too many (testing the mock) — per the doctrine layer's
  logic/integrity split.

## Consequences

- A hermetic logic test is two mocks away: redirect the template tree and the config discovery, and nothing production is in play.
- Mocking whole boundary functions keeps tests decoupled from implementation — a refactor inside a seam never rewrites the suite.
- The gotchas are institutional memory: each entry is a failure mode that cost real debugging time, written down so it is paid once.

## Dora explains:

DORA's research on test automation emphasizes isolation and reproducibility—and Pester's gotchas tempt tightly coupled tests that fail
mysteriously or mock so broadly they test nothing. Isolating logic through seams (template roots, config discovery), mocking whole functions
only, and splitting logic from integrity tests ensures fast, reliable test feedback.

- [Test automation](https://dora.dev/capabilities/test-automation/) — hermetic logic tests with seam mocks catch regressions fast without
  process-global state leakage.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — seam-based mocking keeps tests decoupled from implementation
  so refactors do not rewrite the suite.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — splitting logic and integrity tests provides both fast
  feedback and real-world coverage.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
