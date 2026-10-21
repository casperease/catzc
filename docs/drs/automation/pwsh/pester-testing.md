# ADR: Pester testing — the language layer over test-automation

## Rules: ADR-PWSH-PESTER

### Rule ADR-PWSH-PESTER-PESTERFRAMEWORK

Pester is the test framework, and a test applies the [test-automation](../test-automation.md) (`ADR-AUTO-TEST`) doctrine — logic isolated
through seams, integrity bound to the real files — with the mock idioms and file conventions below.

- [The idioms](#the-idioms)

### Rule ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS

Isolate logic tests through the seams (ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES, ADR-AUTO-TEST-GENERICTEMPLATETESTS) — in `BeforeEach`, mock
`Get-BicepTemplatesRoot` to a fixture template tree, and isolate config either by mocking the discovery seam `Resolve-ConfigEntry` (return a
fixture `@{ Name; Module; Path }`) or by mocking `Get-Config` itself. Redirecting only the template tree leaks the shipped identities back
in.

- [The idioms](#the-idioms)

### Rule ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES

Mock at module boundaries with `-ModuleName`, and mock the whole boundary function — never its internals (ADR-AUTO-TEST-SAFESEAMSWAPS). A
cached function is varied by mocking the function itself (`Mock Get-BicepTemplates`), because a warm cache ignores mocked dependencies, and
reaching into internals couples the test to implementation. A test of cache population resets its entry in module scope
(`InModuleScope <Module> { $script:<entry> = $null }`, [script-scope-caching](script-scope-caching.md)), and only such a test does.

- [The idioms](#the-idioms)

### Rule ADR-PWSH-PESTER-PRIVATETHROUGHMODULE

Test private functions through the module (`& (Get-Module …) { … }` or `InModuleScope`), injecting metadata by mocking the public seam —
never by editing module-scope state except to reset a cache entry.

- [The idioms](#the-idioms)

### Rule ADR-PWSH-PESTER-TESTFILE

A Pester test file (ADR-AUTO-TEST-TESTFILE) is one `*.Tests.ps1` file under a module's `tests/`: one per function, `Verb-Noun.Tests.ps1` —
`Test-Automation.Tests.ps1` enforces the hyphenated basename. A cross-cutting test file is named after the function it most exercises plus a
suffix (`Verb-Noun.<Suffix>.Tests.ps1`). A test file for a native C# type is named for the type and lives in `tests/types/`
(`<TypeName>.Tests.ps1`) — exempt from Verb-Noun, but the gate requires the name to match a `types/*.cs` in the same module.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-PESTER-STRICTMODE

Tests run under strict mode. A test whose subject genuinely is non-strict behaviour opts out in its own `It` body — `Set-StrictMode -Off` as
the body's first statement, under a comment saying why — never in a `BeforeAll`, a `Describe` body, or the file, and never to get past a
strict failure that a code or fixture fix would remove.

- [Tests under strict mode](#tests-under-strict-mode)

### Rule ADR-PWSH-PESTER-PRODUCTIONSHAPE

A mock or fixture returns the production shape: the typed record the real function returns (`[Catzc.Base.Execution.ToolConfig]::new(…)`,
`[Catzc.Azure.Templates.BicepArtifacts]::new(…)`), or an object carrying every member the code under test reads — never a partial
`[pscustomobject]` that omits an optional member.

- [Tests under strict mode](#tests-under-strict-mode)

### Rule ADR-PWSH-PESTER-TESTISIT

In Pester a test (ADR-AUTO-TEST-TEST) is one `It`. A **test block** is a `Describe` or `Context` in a test file: a named group of tests (and
of nested blocks) whose tags and setup (`BeforeAll`/`BeforeEach`) apply to everything inside it, so a test's tags resolve along its block
chain, nearest block first (ADR-AUTO-TEST-TWOMANDATORYTAGS).

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS

Prefer `[System.IO]` over the other filesystem cmdlets on hot paths — in test setup **and** in the production code under test.
`Copy-Item -Recurse` (~15×) and `New-Item`/`Set-Content` carry heavy per-call provider + AV/AMSI overhead on Windows; the `Copy-Directory`
helper, `[System.IO.File]::WriteAllText`, and `[System.IO.Directory]::CreateDirectory` are ~0.1 ms. This is the same effect as the
bulk-delete gotcha, generalized. Listing folders and files is its own rule: [bounded-enumeration](bounded-enumeration.md) (ADR-PWSH-ENUM).

- [Fast tests in Pester](#fast-tests-in-pester)

### Rule ADR-PWSH-PESTER-TAGVALUES

The tier and category tags of ADR-AUTO-TEST-ONECATEGORY and ADR-AUTO-TEST-TWOMANDATORYTAGS are Pester `-Tag` values. Put both on the
`Describe` for a uniform test file; where the file mixes tiers or categories, override on an inner `Context` (and tag per `Context` when the
categories differ) — never two tags of the same axis on one block. `Get-TestBlockTag` resolves a tag along the test's block chain, and
`Get-TestLevelTag` and `Get-TestCategoryTag` read the two axes through it.

- [The test doctrine in Pester](#the-test-doctrine-in-pester)

### Rule ADR-PWSH-PESTER-SKIPWITHREASON

A test that skips itself (ADR-AUTO-TEST-TAGBYOUTERMOSTRING) calls `Set-ItResult -Skipped -Because '<skip key>'` and then `return`s, with the
constrained skip key as a string literal, so `Test-SourceConventions` can read it from the syntax tree. A vertical test's L2 or L3 tag sits
on its own `Describe`.

- [The test doctrine in Pester](#the-test-doctrine-in-pester)

### Rule ADR-PWSH-PESTER-DISCOVERYONLYPASS

The discovery-only pass of ADR-AUTO-TEST-TAGSENFORCED is a Pester run with `Run.SkipRun` set: Pester discovers every test and its blocks
without running a body, and `Get-TestTagViolations` reads the tags from the discovered tree. The provenance citations of
ADR-AUTO-TEST-PROVENANCETAGS are `-Tag` values on an `It` or any block, and `Get-TestRuleTags` unions them across the test's own tags and
every ancestor block.

- [The test doctrine in Pester](#the-test-doctrine-in-pester)

### Rule ADR-PWSH-PESTER-INTEGRITYPARSESFILES

An integrity test reads its fact from the files (ADR-AUTO-TEST-INTEGRITYREADSFILES) by parsing them with the PowerShell parser
(`[System.Management.Automation.Language.Parser]::ParseFile`) or by reading a `.ps1` basename — never through `Import-Module`,
`Get-Command`, or `Get-Module` on a loaded session.

- [The test doctrine in Pester](#the-test-doctrine-in-pester)

### Rule ADR-PWSH-PESTER-SETUPONCEPERBLOCK

Expensive setup runs once per block (ADR-AUTO-TEST-SETUPONCE): the fixture copy and the one cache reset
(`InModuleScope … { $script:configCache = $null }`) belong in `BeforeAll`, and a `BeforeEach` never hands each test a fresh
`Join-Path $TestDrive ([Guid]::NewGuid())` root unless those tests mutate the same input and would collide.

- [Fast tests in Pester](#fast-tests-in-pester)

### Rule ADR-PWSH-PESTER-CHILDPROCESSPERCASE

A test of a unit that re-derives from the filesystem (ADR-AUTO-TEST-ONEIMPORTPERCASE) starts one child `pwsh` import per distinct tree shape
in `BeforeAll`, captures a JSON observation of it, and asserts that observation across separate `It` blocks. Pester runs a file's `It`
blocks one after another, so splitting a narrative into more `It` blocks parallelizes nothing.

- [Fast tests in Pester](#fast-tests-in-pester)

### Rule ADR-PWSH-PESTER-MEASURESLOWTESTS

A slow test is measured in Pester's own terms (ADR-AUTO-TEST-MEASUREFIRST): sub-steps timed with `[Diagnostics.Stopwatch]`, calls counted
with `Should -Invoke -Times`. A `Mock` intercepts in about a millisecond per call, and a `-ParameterFilter` adds about one more, so a mock
is rarely the cost.

- [Fast tests in Pester](#fast-tests-in-pester)

### Rule ADR-PWSH-PESTER-POOLEDWORKERS

The harness workers of ADR-AUTO-TEST-FILEPARALLELISM are `pwsh` processes, pooled by the `PesterRunner` type: each dot-sources its entry
script, sets `Set-StrictMode -Version Latest` before it invokes Pester, runs its shard, and reduces its **live** Pester result to rows with
`ConvertTo-TestAutomationRowSet`, because tier and category resolve along the result's `.Block` chain, which does not survive a process
boundary. Pester's NUnit output stays per shard (`results-shard-<N>.xml`).

- [The harness in Pester](#the-harness-in-pester)

### Rule ADR-PWSH-PESTER-SHARDENTRYSCRIPT

A shard worker's entry script is the one difference between the two test runs of ADR-AUTO-TEST-SAMETESTSBOTHRUNS: the source run's workers
dot-source `<repo>/importer.ps1`, the build run's dot-source `<build>/Import-Catzc.ps1 -RepositoryRoot <repo>`, and both run the same
`pwsh/<Module>/tests/*.Tests.ps1` files. `Mock -ModuleName`, `InModuleScope`, and `Get-Module` resolve the same in both, because a built
module keeps its name, its functions, and its `$script:` scope.

- [The harness in Pester](#the-harness-in-pester)

### Rule ADR-PWSH-PESTER-ENFORCERKINDS

The two enforcer kinds of ADR-AUTO-TEST-COVERAGEREPORTEDONLY are a `pester-test`, an `It` tagged with the rule's citation, and a
`pssa-rule`, a PSScriptAnalyzer rule mapped to the rule in `analyzer-drs-map.yml` (ADR-PWSH-FORMAT-ANALYZERADRMAPPING), which the
`Test-ScriptAnalyzer` quality gate runs.

- [The harness in Pester](#the-harness-in-pester)

### Rule ADR-PWSH-PESTER-LANGUAGEBRIDGE

The language bridge of ADR-AUTO-TEST-LANGUAGETESTMODULES (ADR-AUTO-GO-LANGUAGEBRIDGE, ADR-AUTO-PY-LANGUAGEBRIDGE,
ADR-AUTO-BASH-LANGUAGEBRIDGE) is one Pester container, `Language.Bridge.ps1` in `Catzc.Base.QualityGates/tests/`, run once per mapped test
folder with the folder, its language, the engine entry, and the path of the language's tool, located once by the run's source session, as
container data: each test of the folder becomes one `It` tagged `L2` and its category, so the tag check, the timing check, and the reports
read it like any Pester test.

- [The harness in Pester](#the-harness-in-pester)

## Context

[test-automation](../test-automation.md) fixes the doctrine: what a test may depend on (logic vs integrity), the L0–L4 tiers, the mandatory
tag axes, the run model, and the push-left economics. This ADR is the Pester layer under it — the concrete mock idioms a hermetic logic test
is written with, the test-file conventions, how each part of the doctrine is written in Pester, and the engine gotchas that repeatedly bite.

## Decision

A logic test mocks the seams (`Get-BicepTemplatesRoot`; `Resolve-ConfigEntry` or `Get-Config`) at module boundaries with `-ModuleName`,
whole functions only; privates are tested through the module; and every test file follows the `Verb-Noun.Tests.ps1` convention.

### The idioms

A hermetic logic test (both seams isolated, fixture identities):

```powershell
Describe 'Get-AzureEnvironment' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-BicepTemplatesRoot { Join-Path (Get-RepositoryRoot) 'pwsh/Catzc.Azure.Templates/tests/assets/templates' } -ModuleName Catzc.Azure.Templates
        # Redirect the 'azure' config to the fixture file via the discovery seam.
        Mock Resolve-ConfigEntry {
            @{ Name = 'azure'; Module = 'Catzc.Azure.Templates'
               Path = Join-Path (Get-RepositoryRoot) 'pwsh/Catzc.Azure.Templates/tests/assets/config/azure.yml' }
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

An L2 vertical test (it crosses the local-tool ring — drives `az bicep build`), tagged and self-skipping:

```powershell
Describe 'sample (real az)' -Tag 'L2', 'logic' {
    It 'compiles with az bicep build' {
        if (-not (Get-Command az -ErrorAction Ignore)) { Set-ItResult -Skipped -Because 'tool_az_missing'; return }
        Build-Bicep sample -Environments alpha | Out-Null
        Join-Path $outputRoot 'main.json' | Should -Exist
    }
}
```

### The test doctrine in Pester

`Each part of the doctrine, written in Pester`

The doctrine speaks of tests, groups of tests, tags, and a discovery pass; Pester gives each a concrete form. A test is an `It`, a group is
a `Describe` or `Context`, and a tag is a `-Tag` value on either. Tags resolve along the block chain, nearest contributing block first,
which is why a uniform file tags its `Describe` once and a mixed file overrides on an inner `Context` (ADR-PWSH-PESTER-TAGVALUES).
Provenance citations ride the same `-Tag` parameter, but they union along the chain instead of taking the nearest
(ADR-PWSH-PESTER-DISCOVERYONLYPASS).

Pester can discover without running: with `Run.SkipRun` it builds the whole tree of blocks and tests, tags included, and executes no body.
That is what makes the tag check cheap enough to run on every invocation, whatever `-Level` asks for.

A skip is a result, not an absence: `Set-ItResult -Skipped -Because` records the reason on the test's row, and the skip report groups by it.
The reason is a literal, never a computed string, so `Test-SourceConventions` checks the key grammar from the syntax tree without running
anything (ADR-PWSH-PESTER-SKIPWITHREASON). The same syntax tree is what an integrity test reads when its fact is about PowerShell files —
the parser answers "which functions does this file define" without loading the file (ADR-PWSH-PESTER-INTEGRITYPARSESFILES).

### Tests under strict mode

The code under test runs strict in its own module scope ([error-handling](error-handling.md)), and the harness worker sets strict mode
before it invokes Pester ([test-automation](../test-automation.md#rule-adr-auto-test-fileparallelism)), so the test code runs strict too.
Strict mode belongs to a scope and Pester runs each `It` body in a child scope of its block: `Set-StrictMode -Off` in one `It` body covers
that body alone — the next `It` and every sibling block stay strict — and never reaches the module code the test calls, which keeps its own
scope. The `It` body is therefore the narrowest place an opt-out works and the only place it belongs; a `BeforeAll` or `Describe`-level
opt-out silently relaxes every test in the block.

```powershell
It 'reads Count on a scalar' {
    # non-strict IS the behaviour under test here: scalar .Count
    Set-StrictMode -Off
    'one'.Count | Should -Be 1
}
```

Strict mode also makes a partial fake fail where production succeeds: reading a member an object does not carry throws, so a mock that
returns a `[pscustomobject]` without an optional key fails on a read the real typed record answers with its default. Returning the
production shape (ADR-PWSH-PESTER-PRODUCTIONSHAPE) keeps the test honest about the contract — a member the real record does not map is
absent in the test exactly as in production.

### Fast tests in Pester

`Where Pester and the PowerShell cmdlets spend the time`

The doctrine's speed rules (ADR-AUTO-TEST-SETUPONCE to ADR-AUTO-TEST-MEASUREFIRST) meet four PowerShell-specific costs:

- **The filesystem-cmdlet tax (ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS).** On Windows the PowerShell file cmdlets carry ~20 ms of per-call
  provider + AV/AMSI overhead that the raw .NET APIs avoid (~0.1 ms): `Copy-Item -Recurse` ~15× a `[System.IO]` tree copy,
  `New-Item`/`Set-Content` similar. It bites **production code** the tests exercise as much as the tests themselves. Listing folders is
  covered by [bounded-enumeration](bounded-enumeration.md) (ADR-PWSH-ENUM). In test setup, copy fixture trees with `Copy-Directory` (the
  `[System.IO]` recursive-copy helper in `Catzc.Base.Files`) and write files with `[System.IO.File]::WriteAllText` /
  `[System.IO.Directory]::CreateDirectory`. The bulk-delete gotcha below is the same effect for deletion.
- **Setup in `BeforeEach` (ADR-PWSH-PESTER-SETUPONCEPERBLOCK).** `Get-BicepTemplates`/`Get-Config` key their session cache on the resolved
  root/path. A `BeforeEach` that assigns each test a fresh `Join-Path $TestDrive ([Guid]::NewGuid())` root, or re-runs
  `InModuleScope … { $script:configCache = $null }`, defeats that cache and pays a full cold re-derive **every test** — on the order of a
  second per test for template-configuration tests. The fixture copy **and** the one-time cache reset belong in `BeforeAll`.
- **Child `pwsh` spawns (ADR-PWSH-PESTER-CHILDPROCESSPERCASE).** A narrative of many steps over the importer collapses to the few tree
  shapes that are actually distinct (empty, a populated tree, a re-derive-after-add/change/delete, a duplicate-name collision, a vendor
  shadow), each capturing a rich JSON observation in `BeforeAll` that many `It` blocks assert against — half the child `pwsh` spawns or
  fewer, with no loss of coverage.
- **Mocks are rarely the cause (ADR-PWSH-PESTER-MEASURESLOWTESTS).** Interception is ~ms/call and a `-ParameterFilter` adds ~1 ms. An
  apparent "mock penalty" is usually a measurement artifact — a no-mock comparison that silently falls through to a smaller real tree times
  a different workload. The real cost shows up under `[Diagnostics.Stopwatch]` timing of the unmocked path and `Should -Invoke -Times`
  invocation counts, and it is usually a filesystem cmdlet.

### The harness in Pester

`The run model, executed by Pester in pwsh workers`

The run model of [test-automation](../test-automation.md) is engine-neutral; its executor is Pester, in pwsh. Each shard worker is a `pwsh`
that dot-sources its run's entry script, sets strict mode, and invokes Pester on its shard (ADR-PWSH-PESTER-POOLEDWORKERS). The worker
reduces the result itself, while the live `.Block` chain still exists for tier, category, and skip-reason resolution, and hands the parent
plain rows: a Pester object does not survive a process boundary, and the parent's reports need only rows. `PesterRunner` pools the workers'
output so the console reads in submission order while the wall clock runs in parallel.

The source run and the build run differ only in the entry script a worker dot-sources (ADR-PWSH-PESTER-SHARDENTRYSCRIPT). A test written for
one runs unchanged in the other, because every name Pester resolves — a `Mock -ModuleName` target, an `InModuleScope` module, a `Get-Module`
lookup — is the same module either way.

Rule coverage counts the enforcers that run in that same Pester invocation (ADR-PWSH-PESTER-ENFORCERKINDS): a tagged `It`, and a
PSScriptAnalyzer rule through its mapping, since the analyzer quality gate runs as an integrity test in the run.

The other test languages reach the run through one Pester container (ADR-PWSH-PESTER-LANGUAGEBRIDGE). Pester runs it once per mapped Go,
Python, or Bash test folder; the container runs the folder's tests through their own tool and emits one `It` per test, so every report reads
them as Pester tests.

### Gotchas

- **`<word>` in an `It` name is Pester data-binding**, not literal text — `'names parameters.<config>.json'` makes Pester look for
  `$config`. Keep angle brackets out of test names.
- **An unbound `[string]` parameter is `''`, not `$null`** — the engine coerces `$null`→`''` for `[string]`, so `$Customer -eq $null` is
  never true for a `[string]` param. Test emptiness with `if (-not $Customer)` or `[string]::IsNullOrEmpty($Customer)`, and never default
  one with `??` (the default won't apply — see
  [automatic-variable-pitfalls](automatic-variable-pitfalls.md#rule-adr-pwsh-autovar-nocoalesceonstrings)).
- **`Where-Object prop -EQ` / `ForEach-Object prop` shortcuts do not bind `[ordered]` dictionary keys** — use the script-block form. This
  codebase returns ordered dicts pervasively.
- **`Should -BeLike` and `Should -Throw` match a `-like` pattern, where `[ ]` is a character class.** A bracketed fragment
  (`"*[Drift]*"`) matches one of its letters, not the brackets; escape it (`` `[Drift`] ``) or compare whole with `-BeExactly`.
- **A comma-wrapped array return piped directly member-enumerates.** `Get-BicepTemplates | Where …` feeds the whole array as one object;
  parenthesise first: `(Get-BicepTemplates) | Where …`.
- **To test that a parameter is mandatory, bind it to `$null` — never omit it.** An _absent_ mandatory parameter makes an interactive host
  **prompt** (and hang), not throw; it only throws under `-NonInteractive`. Supplying the param explicitly as `$null` (with valid values for
  the others) rejects at binding in _every_ host — `{ Invoke-Foo -X $null -Y @{} } | Should -Throw`. Relying on `-NonInteractive` to turn
  the prompt into a throw masks the hazard rather than removing it, so a `Test-Automation` run from a devbox shell hangs.
- **A reused-and-deleted sandbox path races an on-access file scanner.** A `BeforeEach` that deletes and recreates one fixed sandbox dir
  intermittently throws "… being used by another process" on the delete, because a Windows AV / indexer briefly holds a just-copied file
  open. Do not retry the delete (see [retry-as-last-resort](../retry-as-last-resort.md#rule-adr-auto-retry-lastresort)) — remove the need:
  give each test a unique dir, `$script:sandbox = Join-Path $TestDrive ([Guid]::NewGuid())`, copy fixtures in, and drop the cleanup
  entirely. Pester auto-cleans `$TestDrive`, and a unique dir is never re-deleted mid-run. Scratch belongs in `$TestDrive` /
  `[IO.Path]::GetTempPath()`, not `out/`.
- **Bulk deletes: use .NET, not per-item `Remove-Item`.** Clearing many entries with per-item `Remove-Item` is ~50× slower than
  `[IO.File]::Delete` / `[IO.Directory]::Delete($d, $true)` (measured ~33 s vs ~0.6 s for ~4,300 entries) — `Clear-TempFolders`
  (`Catzc.Tooling.Provisioning`) uses the .NET calls for this reason. And do not blame AV for temp slowness without checking: a bloated
  `%TEMP%` (tens of thousands of entries) slows NTFS directory creation, and `%TEMP%` is often AV-excluded while the repo is not.
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
  `@{ Name; Module; Path }`, or mock `Get-Config` outright — the whole function, never its internals (ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES).
  When exercising cache behavior directly, reset the cache entry per [script-scope-caching](script-scope-caching.md)
  (ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES).
- **`Test-Automation.Tests.ps1`** validates the `Verb-Noun.Tests.ps1` filename convention — a type test under `tests/types/` is instead
  named for the `types/*.cs` it covers — and the one-function-per-file rules for source (see
  [one-function-per-file](one-function-per-file.md)).
- **`Get-TestTagViolations`** runs the `Run.SkipRun` discovery pass and resolves every test's tags through `Get-TestBlockTag`
  (ADR-PWSH-PESTER-TAGVALUES, ADR-PWSH-PESTER-DISCOVERYONLYPASS); **`Test-SourceConventions`** reads every
  `Set-ItResult ... -Because '<literal>'` from the syntax tree (ADR-PWSH-PESTER-SKIPWITHREASON).
- **Code review** checks a new test mocks the right boundaries — not too few, not too many (testing the mock) — per the doctrine layer's
  logic/integrity split, and that its setup sits in `BeforeAll` unless its tests collide (ADR-PWSH-PESTER-SETUPONCEPERBLOCK).

## Consequences

- A hermetic logic test is two mocks away: redirect the template tree and the config discovery, and nothing production is in play.
- Mocking whole boundary functions keeps tests decoupled from implementation — a refactor inside a seam never rewrites the tests.
- Every engine-neutral test rule has one written Pester form, so a reviewer checks a test against this ADR rather than translating the
  doctrine each time.
- The gotchas are a shared reference: each entry is an engine failure mode that is hard to diagnose from its symptom, written down so the
  diagnosis is never repeated.
