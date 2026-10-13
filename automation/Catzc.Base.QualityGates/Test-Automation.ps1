<#
.SYNOPSIS
    Runs all Pester tests found across automation modules, sharded across parallel worker processes.
.DESCRIPTION
    The harness parallelizes at whole-file granularity: the run's test files are round-robin sharded across
    worker processes (pwsh children driven by the PesterRunner type), each of which imports the repository,
    runs its shard, writes results-shard-<N>.xml plus a rows-shard-<N>.json sidecar, and streams its output
    through the pool — the first unfinished worker is live, later workers buffer and replay in submission
    order, so the console reads sequentially while the wall clock runs in parallel. Files containing a
    'greedy'-tagged test (tests that fan out heavy machine load of their own but share no state) follow as
    single-file shards through the pool, one file per worker slot; files containing a 'serial'-tagged test
    (tests that mutate state shared across processes) run last in a one-worker phase, alone — see
    [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26). Pester executes tests sequentially
    within a worker; a single file never splits across
    workers.
.PARAMETER MaxLevel
    Maximum test level to run (alias: -Level). Defaults to 3: every tier the run's slot allows. A run that
    owns the working folder runs L0-L3; a run in a snapshot (another run holds the working folder, or
    -Isolated) skips L3 and says so ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
    Tests self-skip when their tool or access is absent,
    so the default stays green on a machine that is missing one.
    Tiers are defined by what a test integrates with (not by speed):
    L0/L1 = unit tests — pure logic with every external boundary mocked. L2 = integrates with a local CLI
    tool for real (e.g. `az bicep build`, python, dotnet), inside the repository. L3 = vertical system tests:
    they change or depend on state outside the repository — the cloud (e.g. `az deployment create`), the
    user's environment, installed tools — so only the run that owns the working folder runs them.
    Level 1 runs L0 + L1. Level 2 runs L0 + L1 + L2. Level 3 runs all.
    Every test must carry exactly one tier tag (L0-L3) and one category tag (logic|integrity); tests
    missing a tag are reported before the run (see Get-TestTagViolations).
.PARAMETER MinLevel
    Minimum test level to run. Defaults to 0 (no lower bound). Tiers below MinLevel are excluded, so
    -MinLevel 2 -MaxLevel 2 runs only L2 tests. Must not exceed MaxLevel.
.PARAMETER Modules
    One or more automation module names to test (tab-completes from Get-AutomationModules). Only the named
    modules' tests/ folders run; dot-prefixed infrastructure (.internal, .scriptanalyzer) is excluded.
    Empty (the default) runs every module plus that infrastructure. Composes with -Level and -Category.
.PARAMETER Category
    Which category of test to run: `Logic` (function-logic tests on mocks/fixtures), `Integrity`
    (tests that read the real repository contents — shipped configs, real templates, the module graph,
    checked-in binaries, conventions), or `Both` (the default). Composes with -Level — e.g.
    `-Level 1 -Category Logic` runs the L0/L1 logic tests only. Implemented by excluding the other
    category's tag.
.PARAMETER Workers
    How many parallel worker processes to shard the test files across. 0 (the default) sizes the pool
    automatically — max(1, ProcessorCount / 4), never more than the file count: past that the box is
    throughput-saturated, so extra workers only inflate per-test wall clock against the level time limits.
    1 runs everything through a single worker process (serialized, but still process-isolated). The serial
    phase always runs one worker, after the parallel shards complete.
.PARAMETER TimeoutSeconds
    Hard ceiling on each execution phase (the parallel pool, then the serial phase). On expiry every worker
    is killed and the run throws. Defaults to 3600.
.PARAMETER Output
    Pester output verbosity level inside each worker. Defaults to 'Detailed' (one line per test with its
    own duration); use 'Normal' for one line per file, or 'Minimal' for just the final tally.
.PARAMETER PassThru
    Returns the run summary object: Result, TotalCount/PassedCount/FailedCount/SkippedCount/NotRunCount,
    DurationSeconds, Rows (the aggregated per-test rows), RunDirectory, and Shards (the shard descriptors).
    By default, no object is returned.
.PARAMETER Rule
    Run only the tests that cite one of these ADR rules (the provenance filter) — e.g. `-Rule ADR-AUTO-ERROR#3`.
    Each value is a citation in `ADR-<CODE>#<n>` form. The run narrows to the files carrying a matching test
    and, within them, to the cited tests (Pester tag include). Composes with -Level/-Category/-Modules. It is
    the executable companion of the rule-coverage report: find a rule's tests, then run just them.
.PARAMETER Marker
    Run a marker's declared blast radius: the named globset's `verify:` scope in globs.yml resolves to
    the module list and tier to run ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7))
    — "which tests do I need to run to verify a change in
    that area-of-control". Mutually exclusive with -Modules; a marker without a verify scope throws with
    the remedy. Find the touched markers for a change with Get-MarkerBlastRadius.
.PARAMETER EnforceTimings
    Fail the run when a test exceeds its level's time limit. Off by default — timings are
    machine-dependent, so the run only *reports* over-limit tests (with their durations) and stays
    green. Pass this (e.g. in a controlled CI lane) to turn the report into a failure.
.PARAMETER OutputFolder
    Base directory for the run report. Every run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/) holding the per-shard results-shard-<N>.xml (Pester NUnit), the
    rows-shard-<N>.json sidecars, summary.md, and tests.csv. Defaults to <out>/test-automation (out/
    locally, the artifact staging directory in a pipeline).
.PARAMETER Isolated
    Run in an isolated snapshot of the working folder even when it is free. A run never waits for another
    ([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)): when another run holds the
    working folder this one runs in a snapshot anyway; this
    switch asks for a snapshot up front — a deterministic run, immune to edits made in the working folder
    while it runs. The report lands in the working folder's out/ either way, and run.json records where the
    run executed.
.PARAMETER KeepSandbox
    Keep the snapshot (when the run used one) after the run instead of deleting it, for a post-mortem.
.EXAMPLE
    Test-Automation
.EXAMPLE
    Test-Automation -Isolated -KeepSandbox   # run in a frozen snapshot of the working folder and keep it
.EXAMPLE
    Test-Automation -Level 2
.EXAMPLE
    Test-Automation -MinLevel 2 -MaxLevel 2   # run only the L2 tier (skip L0/L1)
.EXAMPLE
    Test-Automation -Modules Catzc.Base.ModuleSystem   # run only one module's tests
.EXAMPLE
    Test-Automation -Modules Catzc.Azure, Catzc.Azure.Cli -Level 2   # several modules, through L2
.EXAMPLE
    Test-Automation -Category Integrity   # run only integrity tests (real configs/templates/repo checks)
.EXAMPLE
    Test-Automation -Category Logic       # run only the hermetic logic tests
.EXAMPLE
    Test-Automation -Workers 4            # pin the pool size instead of the automatic sizing
.EXAMPLE
    Test-Automation -Output Detailed -PassThru
.EXAMPLE
    Test-Automation -EnforceTimings   # fail if any test is over its level's limit
.EXAMPLE
    Test-Automation -Rule ADR-AUTO-ERROR#3   # run only the tests that cite ADR-AUTO-ERROR#3
.EXAMPLE
    Test-Automation -Marker foundation   # run the foundation unit's declared verify scope (globs.yml)
.EXAMPLE
    Test-Automation -OutputFolder C:\reports\catzc   # write the run report under a custom base
#>
function Test-Automation {
    [CmdletBinding()]
    param(
        [ValidateSet(0, 1, 2, 3)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3)]
        [Alias('Level')]
        [int] $MaxLevel = 3,

        [ArgumentCompleter({ Get-AutomationModules })]
        [ValidateScript({ $_ -in (Get-AutomationModules) })]
        [string[]] $Modules = @(),

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both',

        [ValidateRange(0, 64)]
        [int] $Workers = 0,

        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds = 3600,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru,

        [switch] $EnforceTimings,

        [ValidatePattern('^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$')]
        [string[]] $Rule = @(),

        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Marker,

        [string] $OutputFolder,

        [switch] $Isolated,

        [switch] $KeepSandbox
    )

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    # -Marker: run the named area-of-control's declared blast radius — its globs.yml verify scope resolves
    # to the module list and tier (Resolve-MarkerVerify,
    # [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)).
    if ($Marker) {
        if ($Modules.Count -gt 0) {
            throw 'Pass -Marker or -Modules, not both — a marker resolves its own module scope.'
        }
        $markerScope = Resolve-MarkerVerify -Name $Marker
        $Modules = @($markerScope.Modules)
        $MaxLevel = $markerScope.Level
    }

    # The harness itself — discovery, tag gates, sharding, workers, rows, reports — is the core both runs
    # share (Invoke-TestAutomationSuite,
    # [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)). The source run loads each
    # worker through the
    # repository importer, the core's default.
    Invoke-TestAutomationSuite -Suite 'Test-Automation' -Title 'Test Automation' -MinLevel $MinLevel -MaxLevel $MaxLevel `
        -Modules $Modules -Category $Category -Workers $Workers -TimeoutSeconds $TimeoutSeconds -Output $Output `
        -PassThru:$PassThru -EnforceTimings:$EnforceTimings -Rule $Rule -OutputFolder $OutputFolder `
        -Isolated:$Isolated -KeepSandbox:$KeepSandbox
}
