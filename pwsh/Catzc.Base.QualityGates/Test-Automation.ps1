<#
---
catzc:
  immutable:
    with_body_sha: adde15099147
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
    docs: "[Test-Automation.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md)"
    cites:
      - ADR-AUTO-TEST-ONESCHEDULINGPOOL
      - ADR-AUTO-TEST-SAMETESTSBOTHRUNS
      - ADR-AUTO-TEST-RUNSNEVERWAIT
      - ADR-AUTO-TEST-SYSTEMTESTSATLTHREE
      - ADR-AUTO-TEST-TESTSUITE
      - ADR-AUTO-TEST-TESTINGINPRODUCTION
      - ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER
      - ADR-PWSH-ASSERT-DECLAREDTIMELIMIT
      - ADR-PWSH-ERROR-THROWNOTWRITEERROR
---
#>

function Test-Automation {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.TestRunResult])]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 3600)]
    param(
        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
        [Alias('Level')]
        [int] $MaxLevel = 3,

        [ArgumentCompleter({ (Get-CatzcModule -EngineTrack).name })]
        [ValidateScript({ $_ -in (Get-CatzcModule -EngineTrack).name })]
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

        [ValidatePattern('^ADR(?:-[A-Z][A-Z0-9]*){3,}$')]
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

    if ($Suite) {
        if ($Modules.Count -gt 0) {
            throw 'Pass -Suite or -Modules, not both — a test suite resolves its own module scope.'
        }
        $suiteScope = Resolve-TestSuite -Name $Suite
        $Modules = @($suiteScope.Modules)
        $MaxLevel = $suiteScope.Level
    }

    Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation' -MinLevel $MinLevel -MaxLevel $MaxLevel `
        -Modules $Modules -Category $Category -Workers $Workers -GreedyGroupSize $GreedyGroupSize -TimeoutSeconds $TimeoutSeconds -Output $Output `
        -PassThru:$PassThru -EnforceTimings:$EnforceTimings -Rule $Rule -Suite $Suite -OutputFolder $OutputFolder `
        -Isolated:$Isolated -KeepSandbox:$KeepSandbox
}
