<#
.SYNOPSIS
    Generates one parallel worker's runner script and returns its shard descriptor.
.DESCRIPTION
    The worker sets strict mode itself, as test scopes chain to it; exit 1 is a failed run, any other code a crash.
    [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25),
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment1)
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
.PARAMETER EntryScript
    Empty loads the source importer; a build run passes its Import-Catzc.ps1, which the Go tests then reuse.
    [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment2)
.PARAMETER EntryParameter
    Ignored without -EntryScript; the build run passes RepositoryRoot so out/ paths still resolve in the repo.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment3)
.PARAMETER LanguageExecutable
    The worker never locates a tool, because a build's engine has no tools.yml entry; an empty entry means none.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment4)
.OUTPUTS
    [pscustomobject] with ShardIndex, Label, ScriptPath, ResultsPath, RowsPath, FilesPath.
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

        # The harness never sets this; only the manual single-check path (Invoke-TestFile) filters by name.
        # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment5)
        [string] $FullNameFilter,

        [string] $EntryScript,

        [hashtable] $EntryParameter = @{},

        [hashtable] $LanguageExecutable = @{}
    )

    Assert-PathExist $RunDirectory -PathType Container

    $repositoryRoot = Get-RepositoryRoot

    # Source and build runs differ only in this entry line; everything after the load is identical.
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment6)
    $entryLine = if ($EntryScript) {
        $entryArguments = foreach ($name in ($EntryParameter.Keys | Sort-Object)) {
            $value = $EntryParameter[$name]
            if ($value -is [bool] -or $value -is [switch]) {
                if ($value) {
                    "-$name"
                }
            }
            else {
                "-$name '$("$value" -replace "'", "''")'"
            }
        }
        (@(". '$($EntryScript -replace "'", "''")'") + @($entryArguments)) -join ' '
    }
    else {
        ". '$repositoryRoot/importer.ps1' -SkipJanitors"
    }
    $scriptPath = Join-Path $RunDirectory "shard-$ShardIndex.ps1"
    $resultsPath = Join-Path $RunDirectory "results-shard-$ShardIndex.xml"
    $rowsPath = Join-Path $RunDirectory "rows-shard-$ShardIndex.json"
    $filesPath = Join-Path $RunDirectory "files-shard-$ShardIndex.json"

    $pathLiteral = ($TestPath | ForEach-Object { "'$_'" }) -join ', '
    $tagLiteral = ($ExcludeTag | ForEach-Object { "'$_'" }) -join ', '
    $includeTagLiteral = ($IncludeTag | ForEach-Object { "'$_'" }) -join ', '
    # Single-quote literal: double any embedded quote (a FullNameFilter is prose — titles carry apostrophes).
    $filterLiteral = "$FullNameFilter" -replace "'", "''"
    # Passing the entry script on lets the Go and Python tests start the same engine the worker loaded.
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment7)
    $entryLiteral = "$EntryScript" -replace "'", "''"
    # Sorted by language so the generated literal is stable; a build's engine cannot locate these tools itself.
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment8)
    $languageEntries = foreach ($language in ($LanguageExecutable.Keys | Sort-Object)) {
        "'$language' = '$("$($LanguageExecutable[$language])" -replace "'", "''")'"
    }
    $languageLiteral = '@{ ' + ($languageEntries -join '; ') + ' }'

    # Strict mode stays inline: it is scope-dynamic, and test scopes chain to the process top scope.
    # [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)
    # [comment:9](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md#comment9)
    $content = @"
`$ErrorActionPreference = 'Stop'
$entryLine
[void] [Catzc.Base.QualityGates.WorkerParentWatch]::Start(2000)
Set-StrictMode -Version Latest
Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/Pester') -Force
`$global:__PesterRunning = `$true
`$config = & (Get-Module Catzc.Base.QualityGates) {
    param(`$path, `$excludeTag, `$includeTag, `$verbosity, `$resultsPath, `$fullNameFilter, `$entryScript, `$languageExecutable)
    New-PesterRunConfiguration -Path `$path -ExcludeTag `$excludeTag -IncludeTag `$includeTag -Verbosity `$verbosity -ResultsPath `$resultsPath -FullNameFilter `$fullNameFilter -EntryScript `$entryScript -LanguageExecutable `$languageExecutable
} @($pathLiteral) @($tagLiteral) @($includeTagLiteral) '$Verbosity' '$resultsPath' '$filterLiteral' '$entryLiteral' $languageLiteral
`$result = Invoke-Pester -Configuration `$config
`$rows = & (Get-Module Catzc.Base.QualityGates) { param(`$runResult) ConvertTo-TestAutomationRowSet -Result `$runResult } `$result
Set-Content -Path '$rowsPath' -Value (ConvertTo-Json -InputObject @(`$rows) -Depth 4) -Encoding utf8
`$files = @(`$result.Containers | Where-Object { `$_.Type -eq 'File' } | ForEach-Object { [pscustomobject]@{ File = `$_.Item.FullName; DurationMs = [int] `$_.Duration.TotalMilliseconds; Result = "`$(`$_.Result)"; ErrorMessage = (@(`$_.ErrorRecord) | ForEach-Object { "`$(`$_.Exception.Message)" }) -join "``n" } })
Set-Content -Path '$filesPath' -Value (ConvertTo-Json -InputObject @(`$files) -Depth 2) -Encoding utf8
exit ([int](`$result.Result -ne 'Passed'))
"@
    Set-Content -LiteralPath $scriptPath -Value $content -Encoding utf8

    [pscustomobject]@{
        ShardIndex  = $ShardIndex
        Label       = "shard-$ShardIndex"
        ScriptPath  = $scriptPath
        ResultsPath = $resultsPath
        RowsPath    = $rowsPath
        FilesPath   = $filesPath
    }
}
