<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#25
  config:
    synopsis: |-
      Builds the one Pester configuration every test invocation path shares — shard workers and the manual
      single-check entry point alike.
    description: |-
      The single living copy of "how this repository invokes Pester" (see one-living-version): Run.Path +
      PassThru, output verbosity, the run's exclude tags, optionally the NUnit result file (shard workers) and
      a full-name filter (the manual single-check path). Both the generated shard scripts
      (New-TestAutomationShardScript, via module scope inside the worker) and Invoke-TestFile consume this, so
      the two invocation paths cannot drift apart. The strict-mode discipline itself (Set-StrictMode -Version
      Latest before Invoke-Pester — tests run strict, see
      [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) stays with the CALLER: strict mode
      is
      scope-dynamic, so only the scope that invokes Pester can set it for the tests.
    parameters:
      Path: The test file(s) or folder(s) to run. A Go test folder runs through the Go bridge (ConvertTo-PesterRunTarget).
      ExcludeTag: Tags excluded from the run (from Get-TestExcludeTag). Empty means no tag filter.
      IncludeTag: |-
        Tags a test must carry to run (Pester Filter.Tag) — the -Rule provenance filter. Empty means no include
        filter (the default); a test still also has to clear ExcludeTag.
      Verbosity: Pester output verbosity.
      ResultsPath: When given, enables the NUnit result file at this path (the shard workers' results-shard-<N>.xml).
      FullNameFilter: When given, filters the run to tests whose full name matches (the manual single-check path).
      EntryScript: |-
        The engine entry of a build run (the build's Import-Catzc.ps1), handed to the language bridge so the Go and
        Python tests start the build; empty for the source run.
      LanguageExecutable: |-
        The managed tool per test language and the executable per engine other than pwsh the run's source session
        located (Get-LanguageTestExecutable: @{ go = <path>; python = <uv path>; <engine> = <path> }), handed to the
        language bridge; an empty entry means there is none.
    outputs: '[object] A PesterConfiguration, the configured, ready-to-invoke configuration, typed object because Pester is vendored and loads later.'
---
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
