<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#25
---
#>

<#
.SYNOPSIS
    Builds the one Pester configuration every test invocation path shares — shard workers and the manual
    single-check entry point alike.
.DESCRIPTION
    The caller sets strict mode, not this function: strict mode is scope-dynamic, so only the Pester caller can set it.
.PARAMETER Path
    The test file(s) or folder(s) to run. A Go test folder runs through the Go bridge (ConvertTo-PesterRunTarget).
.PARAMETER ExcludeTag
    Tags excluded from the run (from Get-TestExcludeTag). Empty means no tag filter.
.PARAMETER IncludeTag
    Empty means no include filter, but a test still has to clear ExcludeTag to run.
.PARAMETER Verbosity
    Pester output verbosity.
.PARAMETER ResultsPath
    When given, enables the NUnit result file at this path (the shard workers' results-shard-<N>.xml).
.PARAMETER FullNameFilter
    When given, filters the run to tests whose full name matches (the manual single-check path).
.PARAMETER EntryScript
    Empty for the source run; a build run sets it so the Go and Python tests start the build, not the source.
.PARAMETER LanguageExecutable
    The run's source session located these once, so the bridge reuses them; an empty entry means there is none.
.OUTPUTS
    [object] A PesterConfiguration, the configured, ready-to-invoke configuration, typed object because Pester is vendored and loads later.
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
