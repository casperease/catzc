<#
.SYNOPSIS
    Runs all Pester tests found across automation modules, sharded across parallel worker processes.
.DESCRIPTION
    The harness parallelizes at whole-file granularity: the run's test files are round-robin sharded across worker...
    [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment1)
.PARAMETER MaxLevel
    Maximum test level to run (alias: -Level).
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33),
    [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment2)
.PARAMETER MinLevel
    Minimum test level to run.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment3)
.PARAMETER Modules
    One or more automation module names to test (tab-completes from Get-AutomationModules).
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment4)
.PARAMETER Category
    Which category of test to run: `Logic` (function-logic tests on mocks/fixtures), `Integrity` (tests that read the...
    [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment5)
.PARAMETER Workers
    How many parallel worker processes to shard the test files across.
    [comment:6](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment6)
.PARAMETER TimeoutSeconds
    Hard ceiling on each execution phase (the parallel pool, then the serial phase).
    [ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)
    [comment:7](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment7)
.PARAMETER Output
    Pester output verbosity level inside each worker.
    [comment:8](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment8)
.PARAMETER PassThru
    Returns the run summary object: Result, TotalCount/PassedCount/FailedCount/SkippedCount/NotRunCount,...
    [comment:9](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment9)
.PARAMETER Rule
    Run only the tests that cite one of these ADR rules (the provenance filter) — e.g.
    [ADR-PWSH-ERROR#3](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error3)
    [comment:10](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment10)
.PARAMETER Suite
    Run a test suite: the named globset's declared `verify:` scope in globs.yml, resolved to the module list and tier...
    [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37),
    [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)
    [comment:11](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment11)
.PARAMETER EnforceTimings
    Fail the run when a test exceeds its level's time limit.
    [comment:12](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment12)
.PARAMETER OutputFolder
    Base directory for the run report.
    [comment:13](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment13)
.PARAMETER Isolated
    Run in an isolated snapshot of the working folder even when it is free.
    [ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)
    [comment:14](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment14)
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
    Test-Automation -Rule ADR-PWSH-ERROR#3   # run only the tests that cite ADR-PWSH-ERROR#3
.EXAMPLE
    Test-Automation -Suite infrastructure   # run the infrastructure test suite (its globs.yml verify scope)
.EXAMPLE
    Test-Automation -OutputFolder C:\reports\catzc   # write the run report under a custom base
#>
function Test-Automation {
    [CmdletBinding()]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 3600)]
    param(
        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
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
        [int] $TimeoutSeconds = (Get-TimeoutSeconds -Command 'Test-Automation'),

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru,

        [switch] $EnforceTimings,

        [ValidatePattern('^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$')]
        [string[]] $Rule = @(),

        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Suite,

        [string] $OutputFolder,

        [switch] $Isolated,

        [switch] $KeepSandbox
    )

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    # -Suite: run a test suite — the named globset's declared verify scope resolves to the module list and tier...
    # [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)
    # [comment:15](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment15)
    if ($Suite) {
        if ($Modules.Count -gt 0) {
            throw 'Pass -Suite or -Modules, not both — a test suite resolves its own module scope.'
        }
        $suiteScope = Resolve-TestSuite -Name $Suite
        $Modules = @($suiteScope.Modules)
        $MaxLevel = $suiteScope.Level
    }

    # The harness itself — discovery, tag checks, sharding, workers, rows, reports — is the core both runs share...
    # [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)
    # [comment:16](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment16)
    Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation' -MinLevel $MinLevel -MaxLevel $MaxLevel `
        -Modules $Modules -Category $Category -Workers $Workers -TimeoutSeconds $TimeoutSeconds -Output $Output `
        -PassThru:$PassThru -EnforceTimings:$EnforceTimings -Rule $Rule -Suite $Suite -OutputFolder $OutputFolder `
        -Isolated:$Isolated -KeepSandbox:$KeepSandbox
}
