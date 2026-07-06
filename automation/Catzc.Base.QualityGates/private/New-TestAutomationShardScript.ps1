<#
.SYNOPSIS
    Generates one parallel worker's runner script and returns its shard descriptor.
.DESCRIPTION
    Writes <RunDirectory>/shard-<N>.ps1 — the script a PesterRunner worker executes as `pwsh -NoProfile
    -File` (modeled on Test-InIsolation's generated runner). The worker dot-sources the repository importer
    (-SkipJanitors), then turns strict mode OFF for its own scope: invoking Pester from a scope the importer
    made strict would leak strict mode into every test body — a behaviour the suite is not written under
    (the harness has always invoked Pester from module session state, which global strict never reaches).
    It then imports vendored Pester, builds its run configuration through the ONE shared builder
    (New-PesterRunConfiguration, reached via module scope — the same builder Invoke-TestFile uses, so the
    worker and manual paths cannot drift), runs the shard's test files with the run's exclude tags, writes
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

        # Tags a test must carry to run (the -Rule provenance filter). Empty means no include filter.
        [string[]] $IncludeTag = @(),

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Detailed',

        # Filter the worker's run to tests whose full name contains this text — the manual single-check path
        # (Invoke-TestFile). Empty means no name filter (the harness never sets one).
        [string] $FullNameFilter
    )

    Assert-PathExist $RunDirectory -PathType Container

    $repositoryRoot = Get-RepositoryRoot
    $scriptPath = Join-Path $RunDirectory "shard-$ShardIndex.ps1"
    $resultsPath = Join-Path $RunDirectory "results-shard-$ShardIndex.xml"
    $rowsPath = Join-Path $RunDirectory "rows-shard-$ShardIndex.json"

    $pathLiteral = ($TestPath | ForEach-Object { "'$_'" }) -join ', '
    $tagLiteral = ($ExcludeTag | ForEach-Object { "'$_'" }) -join ', '
    $includeTagLiteral = ($IncludeTag | ForEach-Object { "'$_'" }) -join ', '
    # Single-quote literal: double any embedded quote (a FullNameFilter is prose — titles carry apostrophes).
    $filterLiteral = "$FullNameFilter" -replace "'", "''"

    # The Pester configuration itself comes from the ONE shared builder (New-PesterRunConfiguration) so this
    # worker path and the manual single-check path (Invoke-TestFile) can never drift apart — the worker has
    # the full toolset imported, so it reaches the private through module scope like ConvertTo-
    # TestAutomationRowSet below. Only the strict-mode discipline stays inline: strict is scope-dynamic and
    # the test scopes chain to the process's top scope, so the worker script itself must be the one to turn
    # it off (tests run without strict — ADR-TEST:25).
    $content = @"
`$ErrorActionPreference = 'Stop'
. '$repositoryRoot/importer.ps1' -SkipJanitors
Set-StrictMode -Off
Import-Module '$repositoryRoot/automation/.vendor/Pester' -Force
`$global:__PesterRunning = `$true
`$config = & (Get-Module Catzc.Base.QualityGates) {
    param(`$path, `$excludeTag, `$includeTag, `$verbosity, `$resultsPath, `$fullNameFilter)
    New-PesterRunConfiguration -Path `$path -ExcludeTag `$excludeTag -IncludeTag `$includeTag -Verbosity `$verbosity -ResultsPath `$resultsPath -FullNameFilter `$fullNameFilter
} @($pathLiteral) @($tagLiteral) @($includeTagLiteral) '$Verbosity' '$resultsPath' '$filterLiteral'
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
