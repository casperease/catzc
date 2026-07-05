# ADR: Test automation — logic tests vs integrity tests, and how to isolate

## Rules: ADR-TEST

### Rule ADR-TEST:1

Classify every test as logic or integrity, and carry it as a mandatory `logic`/`integrity` Pester tag (see ADR-TEST:13). A logic test must
not read a shipped asset; an integrity test exists precisely to read them. A single test is one or the other — a file needing both splits
them across separate `Context`/`Describe` blocks, each tagged.

- [Two kinds of test with opposite dependencies](#two-kinds-of-test-with-opposite-dependencies)

### Rule ADR-TEST:2

Isolate logic tests through the seams — in `BeforeEach`, mock `Get-BicepTemplatesRoot` to a fixture template tree, and isolate config either
by mocking the discovery seam `Resolve-ConfigEntry` (return a fixture `@{ Name; Module; Path }`) or by mocking `Get-Config` itself.
Redirecting only the template tree leaks the shipped identities back in.

- [Isolation comes from seams, not from editing production](#isolation-comes-from-seams-not-from-editing-production)

### Rule ADR-TEST:3

Fixtures own their inputs and use deliberately distinct identities under `tests/assets/` (envs `alpha`/`beta`, customers `acme`/`globex`,
org `tst`) so they cannot collide with production.

- [Isolation comes from seams, not from editing production](#isolation-comes-from-seams-not-from-editing-production)

### Rule ADR-TEST:4

Seam swaps are safe because `Get-Config` and `Get-BicepTemplates` key their session caches on the resolved path/root, so a fixture path and
the real path get separate cache entries. Reset the config cache with `InModuleScope Catzc.Base.Config { $script:configCache = $null }` only
when exercising cache behavior directly.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TEST:5

Mock at module boundaries with `-ModuleName`, and mock the whole boundary function — never its internals. A cached function ignores mocked
dependencies, and reaching into internals couples the test to implementation.

- [The idioms](#the-idioms)

### Rule ADR-TEST:6

Do not mock the unit under test, and do not over-mock. Let the pure logic run for real; mock only the genuine boundaries (filesystem
location, external CLIs, git, pipeline detection).

- [The idioms](#the-idioms)

### Rule ADR-TEST:7

The category (`logic`/`integrity`) is orthogonal to the L0–L3 tier — an L2 test may be either — and there is no required pairing of one
integrity test per logic test. Pure-logic tests use fixtures via the seams; tests that deliberately read the shipped assets to verify real
templates are legitimate and stay on the shipped files — but they bind to the template _set_, never to a named template (ADR-TEST:17).

- [Test tiers (by integration layer)](#test-tiers-by-integration-layer)

### Rule ADR-TEST:8

Tag CLI-tool integration `L2` and cloud-API integration `L3`, each in its own `Describe`, and make both self-skip via
`Set-ItResult -Skipped` when the tool or cloud access is missing. The `-Because` reason is a **constrained skip key** — lowercase alnum
segments joined by `_`, never free prose — so the skip report groups by a stable, sortable vocabulary: platform skips are
`<os>_<only|not>_<detail>` (os = `windows`|`unix`; `only` = runs only there, `not` = cannot run there), tool skips are
`tool_<name>_missing`. `Test-Automation.Tests.ps1` enforces the key grammar.

- [Test tiers (by integration layer)](#test-tiers-by-integration-layer)

### Rule ADR-TEST:9

No test below L3 may depend on cloud connectivity. Unit tests mock those boundaries; L2 needs only the local CLI tool. A test failing
because `az` was not connected is a mis-tiered test, not a flake.

- [Test tiers (by integration layer)](#test-tiers-by-integration-layer)

### Rule ADR-TEST:10

A runtime tripwire enforces "L0/L1 launches no real process": `Test-Automation` sets `$env:CATZC_BLOCK_REAL_PROCESS` and `Invoke-Executable`
throws instead of launching, so a Mock that fails to intercept fails loudly.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TEST:11

Test private functions through the module (`& (Get-Module …) { … }` or `InModuleScope`), injecting metadata by mocking the public seam —
never by editing module-scope state except to reset a cache slot.

- [The idioms](#the-idioms)

### Rule ADR-TEST:12

One test file per function, `Verb-Noun.Tests.ps1` — `Test-Automation.Tests.ps1` enforces the hyphenated basename. A cross-cutting suite is
named after the function it most exercises plus a suffix. A test for a native C# type is named for the type and lives in `tests/types/`
(`<TypeName>.Tests.ps1`) — exempt from Verb-Noun, but the gate requires the name to match a `types/*.cs` in the same module.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TEST:13

Every test carries two mandatory, orthogonal tags, resolved through its block chain (nearest contributing block wins): exactly one tier
`L0|L1|L2|L3` and exactly one category `logic|integrity`. There is no default for either — a test resolving to zero, or to two of the same
axis, is a violation. Put both on the `Describe` for a uniform file; override on an inner block (or tag per `Context`) where the file mixes
tiers or categories — never two tags of the same axis on one block.

- [Two mandatory tag axes](#two-mandatory-tag-axes-tier--category)

### Rule ADR-TEST:14

`logic` = verifies a function's logic on mocks and/or its own fixtures, independent of shipped config; `integrity` = verifies the actual
repository contents (shipped `azure.yml`/`network.yml`/`tools.yml`/…, real templates, the module/type/function graph, checked-in binaries,
file/folder conventions). This is the category axis of ADR-TEST:13.

- [Two mandatory tag axes](#two-mandatory-tag-axes-tier--category)

### Rule ADR-TEST:15

`Test-Automation` enforces ADR-TEST:13 on every invocation: a discovery-only pass (`Get-TestTagViolations`, via Pester `Run.SkipRun`)
inspects every test regardless of `-Level`, and the run throws if any test is missing — or ambiguous on — a tier or category tag.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TEST:16

An integrity test derives its fact by reading the repository's files directly — enumerate and parse them (AST, or the `.ps1` basename) —
never by booting the importer or inspecting a loaded session. A static property of the files on disk is checked by reading the files.

- [An integrity test reads the files, not the importer](#an-integrity-test-reads-the-files-not-the-importer)

### Rule ADR-TEST:17

An integrity test that exercises shipped templates must be **generic**: discover the set with `Get-BicepTemplateNames`/`Get-BicepTemplates`
and assert invariants that hold for _every_ template. It must **never** bind to a specific production template name, nor assert a
production-derived magic value (a rendered secret name, resource name, or parameter-file name). Binding a test to a production identity
makes that test veto the identity's rename or removal — a test must never block a production refactor. Positive, template-specific behaviour
(e.g. a PrePost hook injecting a particular Key Vault reference) is verified as a **logic** test against a **fixture** template
(ADR-TEST:2/ADR-TEST:3), not against the shipped one; the generic integrity test asserts only the structural invariant — "any reference
present is well-formed" — across all shipped templates.

- [Integrity tests are generic, never name-bound](#integrity-tests-are-generic-never-name-bound)

### Rule ADR-TEST:18

Prefer `[System.IO]` over filesystem cmdlets on hot paths — in test setup **and** in the production code under test. `Get-ChildItem` (~20
ms/call), `Copy-Item -Recurse` (~15×), and `New-Item`/`Set-Content` carry heavy per-call provider + AV/AMSI overhead on Windows;
`[System.IO.Directory]::EnumerateFiles`/`EnumerateDirectories`, the `Copy-Directory` helper, `[System.IO.File]::WriteAllText`, and
`[System.IO.Directory]::CreateDirectory` are ~0.1 ms. This is the same effect as the bulk-delete gotcha, generalized.

- [Keeping logic tests fast](#keeping-logic-tests-fast)

### Rule ADR-TEST:19

Do expensive setup once, not per test. Discovery and config caches key on the resolved root/path (ADR-TEST:4), so a `BeforeEach` that hands
each test a fresh root or re-nulls `$configCache` forces a cold re-derive on every test. Copy the fixture tree and reset the cache **once**
in `BeforeAll`; share one warm import across tests that do not conflict (read-only, or each writing a distinct path), and give a fresh root
only to tests that mutate-and-collide.

- [Keeping logic tests fast](#keeping-logic-tests-fast)

### Rule ADR-TEST:20

When the unit is a pure function of the filesystem (the importer; discovery), spawn one import per distinct tree shape, not per assertion.
Capture a rich observation from a single import and assert its facets across separate `It` blocks. Minimize the spawn count — Pester
executes tests sequentially within a run, and the harness parallelizes at whole-file granularity (test files sharded across worker
processes), so splitting a stateful narrative into more tests in one file parallelizes nothing; fewer, richer imports is the only lever.

- [Keeping logic tests fast](#keeping-logic-tests-fast)

### Rule ADR-TEST:21

Measure before optimizing a slow test, and compare like workloads. Mock interception is cheap (~ms/call; a `-ParameterFilter` adds ~1 ms),
so "slow because of mocks" is almost always wrong — time sub-steps with `[Diagnostics.Stopwatch]`, count calls with `Should -Invoke -Times`,
and make sure A/B variants do the same work (a redirect that silently falls through to the real tree is measuring a smaller, different
workload).

- [Keeping logic tests fast](#keeping-logic-tests-fast)

### Rule ADR-TEST:22

A cluster of slow integration tests that differ only by input — each re-proving the _same_ cross-boundary wiring for a different case — is a
design signal, not a cost to accept: **push the per-case assertions left** into fast, deterministic, mocked **L0** logic tests, and leave
the integration tier a thin walking skeleton. The thing under test is **the-state-of-this-commit** — everything-as-code (IaC templates, the
`*.yml` configs, the module/type/function graph; see [everything-as-code](../principles/everything-as-code.md)) is a static, hermetic
property of the committed artifacts — so the per-case behaviour is pure logic provable on mocks, and the default gate is a fast check on
those artifacts rather than a slow tool or cloud round-trip.

- [Push the rule-checks left; keep a thin walking skeleton](#push-the-rule-checks-left-keep-a-thin-walking-skeleton)

### Rule ADR-TEST:23

Keep **a very few** integration tests (L2/L3) — one per _distinct_ integration concern, a capability the mock necessarily fakes away (a real
compiler resolving and inlining a referenced module, a subscription-scoped template actually compiling, a CLI's exit-code contract) —
**never one per input case**. Pick the broadest single thread that exercises the wiring, prove the boundary connects once, and let the input
variations live at L0. Two tests that drive the boundary the same way and differ only in rendered values are one walking skeleton plus a
redundant copy; collapse them.

- [Push the rule-checks left; keep a thin walking skeleton](#push-the-rule-checks-left-keep-a-thin-walking-skeleton)

### Rule ADR-TEST:24

The Build Verification Test is the aggregate gate that certifies a commit: it runs the full gated suite for the target level together with
the artifact-canonicalization checks, and is the end gate of both pre- and post-commit-to-master in trunk-based development. A commit
reaches master only when its BVT is green, and the canonical module-manifest artifact a passing build produces is the BVT's gold output.

- [The Build Verification Test](#the-build-verification-test)

## Context

[Fail fast with inline assertions](fail-fast-with-asserts.md) makes the case that automation code is mostly _impure_ — it orchestrates
external systems — so assertions and integration runs catch the failure modes that matter, and **mock-heavy tests are fragile and
misleading**. That ADR is about where confidence comes from. This one is about the Pester tests that remain: there is real _pure_ logic in
this codebase — name assembly (`Get-AzureResourceName`), config resolution (`Get-AzureSubscription`, `Resolve-BicepConfigName`), discovery
shaping (`Get-BicepTemplates`), the cross-layer joins — and that logic deserves fast, deterministic tests. The question this ADR answers is
**what those tests may depend on**.

### Two kinds of test with opposite dependencies

A Pester test in this repo is one of two things, and conflating them is the mistake to avoid:

- **Logic / unit test** — verifies what a _function_ does. It must be **isolated from the shipped configuration**: editing
  `configs/azure.yml` (renaming an environment, dropping a customer, changing a shortcode) must never change the outcome of a test for
  `Get-AzureSubscription` or `Get-BicepResourceName`. A logic test that reads production config is really testing the config, by accident,
  and becomes a tripwire that fires on unrelated edits.

- **Integrity test** — verifies that the _shipped assets and templates are internally consistent_: that `azure.yml`/`network.yml` validate,
  that every real template references a defined environment and customer. It must bind to the **real files** — that is its entire purpose —
  and **nothing else may depend on it**.

The coupling to eliminate is one file serving as both production identity _and_ implicit test fixture: `azure.yml` is production identity
only, and a logic test reads its own fixtures.

### An integrity test reads the files, not the importer

An integrity test verifies a _static_ property of the repository — the file/folder conventions, the module/type/function graph, that every
function name is unique, that a shipped asset validates. It must establish that property by reading the repository directly: enumerate the
files and parse them (AST, or just the `.ps1` basename), build the list, then assert. It must **not** boot the importer, import a module, or
inspect a loaded session to derive a fact that is a pure function of the files on disk — that is slow, indirect, and couples the test to
load mechanics instead of to the thing being checked. The shapes to copy are `Test-Automation.Tests.ps1`'s global function-name uniqueness
check and `Test-FolderConventions.Tests.ps1`: scan the tree, build the list, assert. A _logic_ test that exercises importer behaviour itself
— the bootstrap sandbox cases in `Import-AllModules.Tests.ps1` — legitimately runs the importer, because there the loader _is_ the unit
under test, not a static fact about the files. Enforced in review.

### Integrity tests are generic, never name-bound

An integrity test that builds shipped templates verifies "what we ship actually builds and is internally consistent". That property is about
the template _set_, not any one member — so the test must **discover** the set and assert invariants that hold for every template, never
hardcode a template name or a value derived from one. A test that calls `Build-Bicep <name>` for a specific shipped template and asserts a
magic rendered value (a secret name, a resource name, a parameter-file name) takes production hostage — rename that template, retune its Key
Vault, or delete it, and a green suite turns red for a change that is correct. A test must never be the reason a production refactor cannot
happen.

The design is two-layered, and the split falls out of [ADR-TEST:1](#rule-adr-test1)'s logic-vs-integrity line:

- **Generic integrity** (`Build-Bicep.Integrity.Tests.ps1`) loops `Get-BicepTemplateNames` and asserts, for _every_ shipped template: it
  builds, it renders one parameter file per slot, each is valid, and **any** Key Vault reference present is well-formed (ARM vault-id shape,
  non-empty secret). It asserts the _shape_ of a reference, never _which_ parameter is one — that is template-specific knowledge it must not
  carry. A template added later is covered with no new test.
- **Positive, per-template behaviour** belongs to a **logic** test on a **fixture**. The reason it cannot be generic is structural: a
  PrePost hook's contract ("`sqlAdminPassword` becomes a reference to `<short>-sql-admin-password` in the foundation vault") lives as
  imperative code in that template's `PrePost.psm1`, not as data a generic test could read. So the mechanism is proven once, on the
  `sample-with-prepost` fixture, which injects a Key Vault reference whose secret name is derived from the _fixture's_ own `short_name` and
  whose vault id is built from the _fixture's_ resolved subscription — fixture identities (ADR-TEST:3), asserted against the fixture,
  binding to nothing in production.

This is the same coupling-break as the rest of this ADR (logic tests own their inputs; integrity tests read reality), applied to the
template _name_ dimension: production identities flow into the generic check as discovered data, never as literals a test pins.

### Isolation comes from seams, not from editing production

The codebase already isolates the _template tree_ behind a mockable private function, `Get-BicepTemplatesRoot`, so discovery can be
redirected to a fixture tree. Config has its own seam: `Get-Config` (in `Catzc.Base.Config`) finds a config's file by scanning
`automation/*/configs/` through the private `Resolve-ConfigEntry`, so a logic test isolates a config by **mocking `Resolve-ConfigEntry`** to
return a fixture `@{ Name; Module; Path }` pointing at a fixture file (or by mocking `Get-Config` outright). **A seam is a single function
that names _where_ an input comes from**, with one production answer and a test override; it is the [poka-yoke](../principles/poka-yoke.md)
way to isolate without touching production data.

### Two mandatory tag axes (tier + category)

Every test is tagged on **two orthogonal axes**, and `Test-Automation` fails the run if either is missing (see
[How this is enforced](#how-this-is-enforced)):

- **Tier** (`L0`/`L1`/`L2`/`L3`) — _what it integrates with_ (below). Mandatory; there is no default.
- **Category** (`logic`/`integrity`) — _what it depends on_ (the two kinds above): `logic` runs on mocks/fixtures and is hermetic;
  `integrity` reads the real repository contents.

The two are independent — an `L2` test can be `logic` (drives a tool on a fixture) or `integrity` (builds a real shipped template). Tags
resolve **nearest contributing block wins**: put both on the `Describe` for a uniform file, or override on an inner `Context` (and tag
per-`Context` when a file mixes categories). The one rule: never two tags of the same axis on one block.

Each axis is also a run filter on `Test-Automation`: `-Level` bounds the tier (L0–L3), and `-Category logic|integrity` runs a subset by
category (omit it to run both). Both work by excluding the unwanted tags, so a mixed file's per-`Context` category tags filter correctly —
the `Describe` carries only the tier.

### Test tiers (by integration layer)

Vendor test tooling is lazy-loaded to protect importer time (see
[vendor-toolset-dependencies](vendor-toolset-dependencies.md#rule-adr-vendor5)). Tests are tagged by **what they integrate with**, not by
speed:

- **L0 / L1 — unit.** Pure logic + orchestration wiring, with every external boundary mocked. Deterministic and hermetic. Run on every
  change. (The tier tag is mandatory — there is no default; see ADR-TEST:13.)
- **L2 — CLI-tool integration.** Drives a local CLI tool for real — `az bicep build`, `python`, `dotnet`, `poetry`, … No cloud. Runs on a
  devbox **and in fast CI** (where the tools are installed); a test **self-skips** when its specific tool is absent. Both the devbox and the
  pipeline default to Level 2, so L2 runs by default; `-Level 1` excludes it for a faster unit-only pass.
- **L3 — cloud-API integration.** Talks to the real cloud API layer (maybe through a CLI tool, e.g. `az deployment create` /
  `az account show`). Opt-in (`-Tag 'L3'`), needs cloud credentials / connectivity, and **self-skips** when unavailable. This is the
  integration sliver that [fail-fast](fail-fast-with-asserts.md) argues you cannot rely on alone — kept thin and out of the inner loop. (No
  cloud-API tests exist yet — the tier is reserved for them.)

### Keeping logic tests fast

Logic tests run on every change, so their speed compounds. Four effects, measured in this codebase, dominate — and the fixes are cheap:

- **The filesystem-cmdlet tax (ADR-TEST:18).** On Windows the PowerShell file cmdlets carry ~20 ms of per-call provider + AV/AMSI overhead
  that the raw .NET APIs avoid (~0.1 ms): `Get-ChildItem` ~20 ms/call, `Copy-Item -Recurse` ~15× a `[System.IO]` tree copy,
  `New-Item`/`Set-Content` similar. It bites **production code** the tests exercise as much as the tests themselves — a cold
  `Get-BicepTemplates` discovery made ~36 `Get-ChildItem` calls (~800 ms of a ~1.2 s discovery); switching it to
  `[System.IO.Directory]::EnumerateFiles`/`EnumerateDirectories` (sorted, to keep output deterministic) cut that to ~165 ms, in tests _and_
  in production. In test setup, copy fixture trees with `Copy-Directory` (the `[System.IO]` recursive-copy helper in `Catzc.Base.Files`) and
  write files with `[System.IO.File]::WriteAllText` / `[System.IO.Directory]::CreateDirectory`. The bulk-delete gotcha below is the same
  lesson for deletion.

- **Don't redo expensive setup per test (ADR-TEST:19).** `Get-BicepTemplates`/`Get-Config` key their session cache on the resolved root/path
  (ADR-TEST:4). A `BeforeEach` that assigns each test a fresh `Join-Path $TestDrive ([Guid]::NewGuid())` root, or re-runs
  `InModuleScope … { $script:configCache = $null }`, defeats that cache and pays a full cold re-derive **every test**. The
  `Get-`/`Set-BicepTemplateConfiguration` logic tests each cost ~1.5 s/test this way; moving the fixture copy **and** the one-time cache
  reset into `BeforeAll` (and pointing the few mutating tests at distinct config paths so they can share one tree) dropped them to a single
  warm import. Reset a cache per test only when the test mutates the cached input.

- **One import per input, not per assertion (ADR-TEST:20).** When the unit under test re-derives its result from the filesystem on each run
  — the importer, discovery — every distinct tree shape needs its own cold import, but every _assertion_ does not. `Import-AllModules`
  re-spawned a child `pwsh` for all 14 narrative steps; collapsed to the five tree shapes that are actually distinct (empty, a populated
  tree, a re-derive-after-add/change/delete, a duplicate-name collision, a vendor shadow), each capturing a rich JSON observation that many
  `It` blocks assert against, it dropped from ~10.7 s to ~5.3 s with no loss of coverage. Reduce the spawn _count_; splitting the narrative
  buys no concurrency — Pester executes tests sequentially within a run, the harness parallelizes whole test files across worker processes
  (a single file's tests never split across workers), and these narratives are stateful besides.

- **Measure; mocks are rarely the cause (ADR-TEST:21).** The instinct to blame slowness on Pester mocking is almost always wrong:
  interception is ~ms/call and a `-ParameterFilter` adds ~1 ms. Here the suspected "6× mock penalty" on discovery was a measurement artifact
  — the no-mock comparison had silently fallen through to the real (smaller) template tree, so it was timing a different workload. The
  actual cost was `Get-ChildItem`, proven by `[Diagnostics.Stopwatch]` timing of the unmocked path and `Should -Invoke -Times` invocation
  counts.

Cold-import isolation is the one case that legitimately needs a separate **process** (not an in-process runspace): see the Gotchas.

### Push the rule-checks left; keep a thin walking skeleton

When a directory of tests drives a boundary the same way and varies only by input — one slow integration test per case, each compiling,
deploying, or shelling out to re-prove the _same_ wiring for a different fixture — the duplication is telling you the per-case behaviour is
pure logic wearing an integration test's clothes. The response is to **push it left**: the case-by-case assertions move down to fast,
deterministic **L0** logic tests on mocked boundaries — the rule-checks — and the integration tier keeps only a thin **walking skeleton**, a
very few tests that drive the real tool once to prove the wiring connects.

This is sound because the state under test is **the-state-of-this-commit**. Everything here is code — IaC templates, the `*.yml` configs,
the module/type/function graph — so what a test checks is a static, hermetic property of the committed artifacts
([everything-as-code](../principles/everything-as-code.md)): which parameter file a template renders, what name a resource resolves to,
which slots a config set discovers. None of that needs a tool or the cloud to decide; it is fixed by the files in the commit, and a mocked
L0 gate checks it in milliseconds, deterministically, on every change. The one thing the real tool decides that the files do not is the
_integration concern itself_ — what the compiler, CLI, or cloud actually does with those artifacts — and that is exactly, and only, what the
walking skeleton covers. [Fail-fast](fail-fast-with-asserts.md) argues that confidence comes from the integration run; this keeps that run
thin and pushes everything it does not uniquely prove down to the fast gates (ADR-TEST:7, ADR-TEST:8), which is also where
[reduce-waste](../principles/reduce-waste.md) points — the inner loop pays for the slow tier on every change.

The walking-skeleton set is **one test per distinct integration concern, never one per case**. A concern is something the mock necessarily
fakes away — a real `az bicep build` resolving and inlining a referenced module, a subscription-scoped template actually compiling, a CLI's
exit-code contract — so each remaining test buys coverage no L0 test can. Cases that drive the boundary identically and differ only in
rendered values are a single skeleton plus redundant copies.

`Build-Bicep` is the worked pattern. The per-template behaviour — parameter-file names, customer prefixes, indexed slots, the vnet ranges
merged by the PrePost seam, the injected Key Vault reference — lives in the `Build-Bicep.Sample*.Tests.ps1` **L0** blocks, which mock
`Invoke-AzCli` so no real build runs and each assertion is a sub-millisecond check on the rendered artifact. `Build-Bicep.L2.Tests.ps1` is
the walking skeleton: a very few real-`az` builds, one per distinct compiler concern — a resource-group-scoped build wiring `main.json`
alongside its parameter files, a subscription `targetScope` compiling, a reusable module inlined into `main.json` — not one per sample
template. A new sample that varies only its inputs adds L0 rule-checks and no new real build.

### The Build Verification Test

The tiers above answer "what does one test integrate with"; the Build Verification Test (BVT) answers "is this commit shippable at all". It
is the aggregate gate — the whole gated suite for the target level, plus the artifact-canonicalization checks that keep generated manifests
deterministic and formatter-stable — run as one verdict on the-state-of-this-commit. Because everything is a static, hermetic property of
the committed artifacts (ADR-TEST:22), that verdict is reproducible: the same commit yields the same result on a devbox and in CI.

In trunk-based development ([one-living-version](../principles/one-living-version.md#rule-adr-onelive4)) the BVT is the end gate on both
sides of master — a change integrates only when its BVT is green, and master stays green because nothing merges that has not passed it. Its
gold output is the canonical module-manifest artifact a passing build produces — the reproducible encapsulation of what the commit built,
byte-identical for a given commit.

## Decision

Separate **logic tests** (isolated from shipped config via seams + fixtures) from **integrity tests** (bound to the shipped assets, depended
on by nothing). Mock only at module boundaries, mock whole functions, and let pure logic run for real.

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
  one with `??` (the default won't apply — see [automatic-variable-pitfalls](powershell/automatic-variable-pitfalls.md#rule-adr-autovar6)).
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
  open. Do not retry the delete (see [retry-as-last-resort](retry-as-last-resort.md#rule-adr-retry2)) — remove the need: give each test a
  unique dir, `$script:sandbox = Join-Path $TestDrive ([Guid]::NewGuid())`, copy fixtures in, and drop the cleanup entirely. Pester
  auto-cleans `$TestDrive`, and a unique dir is never re-deleted mid-run. Scratch belongs in `$TestDrive` / `[IO.Path]::GetTempPath()`, not
  `out/` (see [dedicated-output-directory](../repository/dedicated-output-directory.md#rule-adr-outdir3)).
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

- **Two mandatory tags per test** — before the run, `Test-Automation` calls `Get-TestTagViolations`, a discovery-only Pester pass
  (`Run.SkipRun`) that inspects every test regardless of `-Level`; the run throws if any test resolves to zero — or more than one — tier
  (`L0-L3`) or category (`logic|integrity`) tag. `Get-TestLevelTag`/`Get-TestCategoryTag` (in `Catzc.Base.QualityGates`) do the
  nearest-contributing-block resolution.
- **The seams exist** as mockable functions (`Get-BicepTemplatesRoot` for the template tree; `Resolve-ConfigEntry` and `Get-Config` for
  config), so isolation is a mock away and production has a single pristine default.
- **For config, the boundary to mock is `Resolve-ConfigEntry` (the discovery seam) or `Get-Config`** — the unified config reader all reads
  route through (see [module-config-loading](module-config-loading.md)). Mock the discovery seam to return a fixture
  `@{ Name; Module; Path }` pointing at a fixture file, or mock `Get-Config` outright; mock the whole function, never its internals (per
  Rule ADR-TEST:5). When exercising cache behavior directly, reset the slot with
  `InModuleScope Catzc.Base.Config { $script:configCache = $null }`.
- **`Test-Automation.Tests.ps1`** validates the `Verb-Noun.Tests.ps1` filename convention — a type test under `tests/types/` is instead
  named for the `types/*.cs` it covers — and the one-function-per-file rules for source (see
  [one-function-per-file](one-function-per-file.md)). It also AST-scans every test for `Set-ItResult ... -Because '<literal>'` and fails any
  reason that is not a constrained skip key (lowercase alnum segments joined by `_`).
- **Seam-mocking isolates pure-logic tests;** the tests that bind to shipped assets (the cross-layer reference check and the generic
  template-build integrity check) are the sanctioned exceptions — an input-source choice, not a tier — and they bind to the template _set_,
  never to a named template (ADR-TEST:17). The fixtures under `tests/assets/` are the patterns new logic tests copy (see
  [conventional-folders](../repository/conventional-folders.md)).
- **Code review** decides whether a new test verifies _pure logic_ (seam-isolated, hermetic) or _shipped templates_ (binds to assets, only
  external tools mocked), and checks it mocks the right boundaries — not too few, not too many (testing the mock).

## Consequences

- Editing the shipped `azure.yml`/`network.yml`/templates cannot break a _hermetic logic_ test — only the tests that deliberately bind to
  shipped assets (the cross-layer reference check and the generic template-build integrity check), which is exactly where such a change
  _should_ be felt. _Renaming or removing_ a template, however, must not break a test either: the integrity check binds to the template set,
  not to a name (ADR-TEST:17).
- Logic tests are fast and hermetic: no `az`, no network, no dependence on what happens to be in the shipped config today. They run on every
  change.
- The shipped configuration still has a guardian: the generic integrity tests fail loudly if a real template references an undefined
  environment/customer, stops building/rendering, emits a malformed Key Vault reference, or an asset stops validating — for _every_ shipped
  template, including ones added later, with no per-template test to write.
- Distinct fixture identities make a test's independence visible — a reviewer sees `alpha`/`acme`/`tst` and knows nothing production is in
  play.
- The cost: two artifacts to maintain (fixture config + shipped config). They are independent by design; the fixture tracks the test's
  needs, the shipped file tracks reality, and the integrity test guards the latter.
