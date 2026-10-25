<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/New-TestAutomationShardScript.ps1.md"
  warning: "Generated Header"
---
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

        [string[]] $IncludeTag = @(),

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Detailed',

        [string] $FullNameFilter,

        [string] $EntryScript,

        [hashtable] $EntryParameter = @{},

        [hashtable] $LanguageExecutable = @{}
    )

    Assert-PathExist $RunDirectory -PathType Container

    $repositoryRoot = Get-RepositoryRoot

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
    $entryLiteral = "$EntryScript" -replace "'", "''"
    $languageEntries = foreach ($language in ($LanguageExecutable.Keys | Sort-Object)) {
        "'$language' = '$("$($LanguageExecutable[$language])" -replace "'", "''")'"
    }
    $languageLiteral = '@{ ' + ($languageEntries -join '; ') + ' }'

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
