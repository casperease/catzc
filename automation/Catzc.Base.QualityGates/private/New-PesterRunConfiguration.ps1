# catzc:
#   path: automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Builds the one Pester configuration every test invocation path shares — shard workers and the manual
    single-check entry point alike.
.DESCRIPTION
    The caller sets strict mode, not this function: strict mode is scope-dynamic, so only the Pester caller can set it.
    [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment1)
.PARAMETER Path
    The test file(s) or folder(s) to run. A Go test folder runs through the Go bridge (ConvertTo-PesterRunTarget).
.PARAMETER EntryScript
    Empty for the source run; a build run sets it so the Go and Python tests start the build, not the source.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment2)
.PARAMETER LanguageExecutable
    The run's source session located these once, so the bridge reuses them; an empty entry means there is none.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment3)
.PARAMETER ExcludeTag
    Tags excluded from the run (from Get-TestExcludeTag). Empty means no tag filter.
.PARAMETER IncludeTag
    Empty means no include filter, but a test still has to clear ExcludeTag to run.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment4)
.PARAMETER Verbosity
    Pester output verbosity.
.PARAMETER ResultsPath
    When given, enables the NUnit result file at this path (the shard workers' results-shard-<N>.xml).
.PARAMETER FullNameFilter
    When given, filters the run to tests whose full name matches (the manual single-check path).
.OUTPUTS
    [PesterConfiguration] The configured, ready-to-invoke configuration.
#>
function New-PesterRunConfiguration {
    [OutputType([object])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Path,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [AllowEmptyCollection()]
        [string[]] $IncludeTag = @(),

        [ValidateSet('None', 'Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Detailed',

        [string] $ResultsPath,

        [string] $FullNameFilter,

        [string] $EntryScript,

        [hashtable] $LanguageExecutable = @{}
    )

    $target = ConvertTo-PesterRunTarget -Path $Path -EntryScript $EntryScript -LanguageExecutable $LanguageExecutable
    $config = New-PesterConfiguration
    if ($target.Path.Count -gt 0) {
        $config.Run.Path = $target.Path
    }
    if ($target.Container.Count -gt 0) {
        $config.Run.Container = $target.Container
    }
    $config.Run.PassThru = $true
    $config.Output.Verbosity = $Verbosity
    if ($ExcludeTag.Count -gt 0) {
        $config.Filter.ExcludeTag = $ExcludeTag
    }
    if ($IncludeTag.Count -gt 0) {
        $config.Filter.Tag = $IncludeTag
    }
    if ($FullNameFilter) {
        $config.Filter.FullName = "*$FullNameFilter*"
    }
    if ($ResultsPath) {
        $config.TestResult.Enabled = $true
        $config.TestResult.OutputFormat = 'NUnitXml'
        $config.TestResult.OutputPath = $ResultsPath
        $config.TestResult.OutputEncoding = 'UTF8'
        $config.TestResult.TestSuiteName = 'Catzc'
    }

    $config
}
