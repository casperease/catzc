<#
.SYNOPSIS
    Runs all Pester tests found across automation modules, sharded across parallel worker processes.
.DESCRIPTION
    Whole files, never single tests, are the unit of sharding; serial-tagged files run last, alone.
    [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment1)
.PARAMETER MaxLevel
    Defaults to 3, the tiers the run's location allows: a snapshot run skips L3 and says so.
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33),
    [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment2)
.PARAMETER MinLevel
    -MinLevel 2 -MaxLevel 2 runs only the L2 tests; MinLevel must not exceed MaxLevel.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment3)
.PARAMETER Modules
    Dot-prefixed infrastructure (.internal, .scriptanalyzer) runs only when this is left empty.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment4)
.PARAMETER Category
    Implemented by excluding the other category's tag, so it composes with -Level.
    [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment5)
.PARAMETER Workers
    Auto size is max(1, ProcessorCount / 4); past that the box saturates and extra workers inflate per-test time.
    [comment:6](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment6)
.PARAMETER TimeoutSeconds
    On expiry every worker is killed and the run throws; the default is this function's own time limit.
    [ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)
    [comment:7](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment7)
.PARAMETER Output
    Detailed gives one line per test with its duration, Normal one line per file, Minimal only the final tally.
    [comment:8](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment8)
.PARAMETER PassThru
    Without it no object comes back; with it the aggregated per-test rows and the shard descriptors do.
    [comment:9](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment9)
.PARAMETER Rule
    The run narrows to the files carrying a matching test, then to the cited tests through a Pester tag include.
    [ADR-PWSH-ERROR#3](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error3)
    [comment:10](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment10)
.PARAMETER Suite
    Mutually exclusive with -Modules; a globset without a verify scope is no suite and throws.
    [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37),
    [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)
    [comment:11](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment11)
.PARAMETER EnforceTimings
    Timings depend on the machine, so by default over-limit tests are only reported and the run stays green.
    [comment:12](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment12)
.PARAMETER OutputFolder
    Every run writes its own timestamped subfolder, so repeated runs never overwrite each other.
    [comment:13](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment13)
.PARAMETER Isolated
    A snapshot run is deterministic and immune to edits made meanwhile; its report still lands in the working out/.
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

    # The suite resolves its own module list and tier, so passing -Modules as well is rejected.
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

    # Both entry points share this core; the source run loads each worker through the repository importer.
    # [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)
    # [comment:16](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment16)
    Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation' -MinLevel $MinLevel -MaxLevel $MaxLevel `
        -Modules $Modules -Category $Category -Workers $Workers -TimeoutSeconds $TimeoutSeconds -Output $Output `
        -PassThru:$PassThru -EnforceTimings:$EnforceTimings -Rule $Rule -Suite $Suite -OutputFolder $OutputFolder `
        -Isolated:$Isolated -KeepSandbox:$KeepSandbox
}
