<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Automation.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#30
      - ADR-AUTO-TEST#32
      - ADR-AUTO-TEST#33
      - ADR-AUTO-TEST#37
      - ADR-AUTO-TEST#41
      - ADR-FLOW-CD-GLOBS#7
      - ADR-PWSH-ASSERT#1
      - ADR-PWSH-ERROR#3
---
#>

<#
.SYNOPSIS
    Runs all Pester tests found across automation modules, sharded across parallel worker processes.
.DESCRIPTION
    Whole files, never single tests, are the unit of sharding; serial-tagged files run last, alone.
.PARAMETER MinLevel
    -MinLevel 2 -MaxLevel 2 runs only the L2 tests; MinLevel must not exceed MaxLevel.
.PARAMETER MaxLevel
    Defaults to 3, the tiers the run's location allows: a snapshot run skips L3 and says so.
.PARAMETER Modules
    Dot-prefixed infrastructure (.internal, .scriptanalyzer) runs only when this is left empty.
.PARAMETER Category
    Implemented by excluding the other category's tag, so it composes with -Level.
.PARAMETER Workers
    Auto size is max(1, ProcessorCount / 4); past that the box saturates and extra workers inflate per-test time.
.PARAMETER GreedyGroupSize
    Greedy files run side by side in groups of this size, one group after another; 0 reads greedy_group_size from test-policy.yml.
.PARAMETER TimeoutSeconds
    On expiry every worker is killed and the run throws; the default is this function's own time limit.
.PARAMETER Output
    Detailed gives one line per test with its duration, Normal one line per file, Minimal only the final tally.
.PARAMETER PassThru
    Without it no object comes back; with it the aggregated per-test rows and the shard descriptors do.
.PARAMETER EnforceTimings
    Timings depend on the machine, so by default over-limit tests are only reported and the run stays green.
.PARAMETER Rule
    The run narrows to the files carrying a matching test, then to the cited tests through a Pester tag include.
.PARAMETER Suite
    Mutually exclusive with -Modules; a globset without a verify scope is no suite and throws.
.PARAMETER OutputFolder
    Every run writes its own timestamped subfolder, so repeated runs never overwrite each other.
.PARAMETER Isolated
    A snapshot run is deterministic and immune to edits made meanwhile; its report still lands in the working out/.
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

        [ValidateRange(0, 64)]
        [int] $GreedyGroupSize = 0,

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
    # [comment:16](/docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md#comment16)
    Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation' -MinLevel $MinLevel -MaxLevel $MaxLevel `
        -Modules $Modules -Category $Category -Workers $Workers -GreedyGroupSize $GreedyGroupSize -TimeoutSeconds $TimeoutSeconds -Output $Output `
        -PassThru:$PassThru -EnforceTimings:$EnforceTimings -Rule $Rule -Suite $Suite -OutputFolder $OutputFolder `
        -Isolated:$Isolated -KeepSandbox:$KeepSandbox
}
