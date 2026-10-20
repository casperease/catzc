<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
    folder: private
    name: new-pester-run-configuration
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/New-PesterRunConfiguration.Tests.ps1
    docs: "[New-PesterRunConfiguration.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md)"
    cites:
      - ADR-AUTO-TEST-FILEPARALLELISM
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
