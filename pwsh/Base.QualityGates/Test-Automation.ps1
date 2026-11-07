function Test-Automation {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.TestRunResult])]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 3600)]
    param(
        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
        [Alias('Level')]
        [int] $MaxLevel = [Catzc.Base.Timeouts.TestTiers]::DefaultTop,

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

        [ValidateScript({ (Get-Config -Config drs).CodeForm.IsRule($_) }, ErrorMessage = "'{0}' is not a rule's code of a registered kind")]
        [string[]] $Rule = @(),

        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Suite,

        [string] $OutputFolder,

        [switch] $Isolated,

        [switch] $KeepSandbox,

        [switch] $PostBuild
    )

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    # -Suite resolves the named globset's verify scope to its module list and tier.
    if ($Suite) {
        if ($Modules.Count -gt 0) {
            throw 'Pass -Suite or -Modules, not both — a test suite resolves its own module scope.'
        }
        $suiteScope = Resolve-TestSuite -Name $Suite
        $Modules = @($suiteScope.Modules)
        $MaxLevel = $suiteScope.Level
    }

    $optOutTag = @()
    if ($PostBuild) {
        if ($Rule.Count -gt 0) {
            throw 'Pass -PostBuild or -Rule, not both — the post-build run selects its tests by their tag.'
        }
        Assert-BuiltBundleStore
    }
    else {
        $optOutTag = @('post-build')
    }

    # The harness both runs share: discovery, tag checks, sharding, workers, rows and reports.
    Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation' -MinLevel $MinLevel -MaxLevel $MaxLevel `
        -Modules $Modules -Category $Category -Workers $Workers -GreedyGroupSize $GreedyGroupSize -TimeoutSeconds $TimeoutSeconds -Output $Output `
        -PassThru:$PassThru -EnforceTimings:$EnforceTimings -Rule $Rule -Suite $Suite -OutputFolder $OutputFolder `
        -OptOutTag $optOutTag -Isolated:$Isolated -KeepSandbox:$KeepSandbox -PostBuild:$PostBuild
}
