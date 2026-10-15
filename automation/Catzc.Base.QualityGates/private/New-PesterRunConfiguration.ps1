<#
.SYNOPSIS
    Builds the one Pester configuration every test invocation path shares — shard workers and the manual
    single-check entry point alike.
.DESCRIPTION
    The single living copy of "how this repository invokes Pester" (see one-living-version): Run.Path + PassThru,...
    [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment1)
.PARAMETER Path
    The test file(s) or folder(s) to run. A Go test folder runs through the Go bridge (ConvertTo-PesterRunTarget).
.PARAMETER EntryScript
    The engine entry of a build run (the build's Import-Catzc.ps1), handed to the language bridge so the Go and...
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment2)
.PARAMETER LanguageExecutable
    The managed tool per test language and the executable per engine other than pwsh the run's source session located...
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md#comment3)
.PARAMETER ExcludeTag
    Tags excluded from the run (from Get-TestExcludeTag). Empty means no tag filter.
.PARAMETER IncludeTag
    Tags a test must carry to run (Pester Filter.Tag) — the -Rule provenance filter.
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
