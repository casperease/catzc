<#
.SYNOPSIS
    Builds the one Pester configuration every test invocation path shares — shard workers and the manual
    single-check entry point alike.
.DESCRIPTION
    The single living copy of "how this repository invokes Pester" (see one-living-version): Run.Path +
    PassThru, output verbosity, the run's exclude tags, optionally the NUnit result file (shard workers) and
    a full-name filter (the manual single-check path). Both the generated shard scripts
    (New-TestAutomationShardScript, via module scope inside the worker) and Invoke-TestFile consume this, so
    the two invocation paths cannot drift apart. The strict-mode discipline itself (Set-StrictMode -Off
    before Invoke-Pester — tests run without strict mode, see ADR-TEST:25) stays with the CALLER: strict
    mode is scope-dynamic, so only the scope that invokes Pester can turn it off.
.PARAMETER Path
    The test file(s) or folder(s) to run.
.PARAMETER ExcludeTag
    Tags excluded from the run (from Get-TestExcludeTag). Empty means no tag filter.
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

        [ValidateSet('None', 'Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Detailed',

        [string] $ResultsPath,

        [string] $FullNameFilter
    )

    $config = New-PesterConfiguration
    $config.Run.Path = $Path
    $config.Run.PassThru = $true
    $config.Output.Verbosity = $Verbosity
    if ($ExcludeTag.Count -gt 0) {
        $config.Filter.ExcludeTag = $ExcludeTag
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
