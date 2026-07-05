<#
.SYNOPSIS
    Generates one parallel worker's runner script and returns its shard descriptor.
.DESCRIPTION
    Writes <RunDirectory>/shard-<N>.ps1 — the script a PesterRunner worker executes as `pwsh -NoProfile
    -File` (modeled on Test-InIsolation's generated runner). The worker dot-sources the repository importer
    (-SkipJanitors), imports vendored Pester, runs the shard's test files with the run's exclude tags, writes
    Pester's NUnit results to results-shard-<N>.xml, reduces its live result to rows (ConvertTo-
    TestAutomationRowSet — tier/category resolution needs the live .Block chain, so it must happen inside the
    worker) into rows-shard-<N>.json, and exits 0 (green) or 1 (the run did not pass — failed tests, or a
    container/discovery error that fails the run with zero failed tests). Any other exit code — or a missing
    rows sidecar — means the worker itself crashed, which the parent surfaces loudly.
.PARAMETER ShardIndex
    The shard's zero-based index — names the script, results, and rows files.
.PARAMETER TestPath
    The shard's test files (absolute *.Tests.ps1 paths).
.PARAMETER RunDirectory
    The run directory the script and its artifacts are written into (must exist).
.PARAMETER ExcludeTag
    Tags excluded from the worker's run (from Get-TestExcludeTag). Empty means no tag filter.
.PARAMETER Verbosity
    Pester output verbosity inside the worker (the run's -Output value).
.OUTPUTS
    [pscustomobject] with ShardIndex, Label, ScriptPath, ResultsPath, RowsPath.
#>
function New-TestAutomationShardScript {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [int] $ShardIndex,

        [Parameter(Mandatory)]
        [string[]] $TestPath,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [string[]] $ExcludeTag = @(),

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Detailed'
    )

    Assert-PathExist $RunDirectory -PathType Container

    $repositoryRoot = Get-RepositoryRoot
    $scriptPath = Join-Path $RunDirectory "shard-$ShardIndex.ps1"
    $resultsPath = Join-Path $RunDirectory "results-shard-$ShardIndex.xml"
    $rowsPath = Join-Path $RunDirectory "rows-shard-$ShardIndex.json"

    $pathLiteral = ($TestPath | ForEach-Object { "'$_'" }) -join ', '
    $excludeLine = if ($ExcludeTag.Count -gt 0) {
        $tagLiteral = ($ExcludeTag | ForEach-Object { "'$_'" }) -join ', '
        "`$config.Filter.ExcludeTag = @($tagLiteral)"
    }
    else {
        ''
    }

    $content = @"
`$ErrorActionPreference = 'Stop'
. '$repositoryRoot/importer.ps1' -SkipJanitors
Import-Module '$repositoryRoot/automation/.vendor/Pester' -Force
`$global:__PesterRunning = `$true
`$config = New-PesterConfiguration
`$config.Run.Path = @($pathLiteral)
`$config.Run.PassThru = `$true
`$config.Output.Verbosity = '$Verbosity'
$excludeLine
`$config.TestResult.Enabled = `$true
`$config.TestResult.OutputFormat = 'NUnitXml'
`$config.TestResult.OutputPath = '$resultsPath'
`$config.TestResult.OutputEncoding = 'UTF8'
`$config.TestResult.TestSuiteName = 'Catzc'
`$result = Invoke-Pester -Configuration `$config
`$rows = & (Get-Module Catzc.Base.QualityGates) { param(`$runResult) ConvertTo-TestAutomationRowSet -Result `$runResult } `$result
Set-Content -Path '$rowsPath' -Value (ConvertTo-Json -InputObject @(`$rows) -Depth 4) -Encoding utf8
exit ([int](`$result.Result -ne 'Passed'))
"@
    Set-Content -LiteralPath $scriptPath -Value $content -Encoding utf8

    [pscustomobject]@{
        ShardIndex  = $ShardIndex
        Label       = "shard-$ShardIndex"
        ScriptPath  = $scriptPath
        ResultsPath = $resultsPath
        RowsPath    = $rowsPath
    }
}
