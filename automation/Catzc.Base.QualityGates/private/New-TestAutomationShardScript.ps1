<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
    folder: private
    name: new-test-automation-shard-script
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-TEST#{25,30}
  config:
    synopsis: Generates one parallel worker's runner script and returns its shard descriptor.
    description: |-
      Writes <RunDirectory>/shard-<N>.ps1 — the script a PesterRunner worker executes as `pwsh -NoProfile
      -File` (modeled on Test-InIsolation's generated runner). The worker dot-sources the repository importer
      (-SkipJanitors), starts watching the process that launched it (WorkerParentWatch — the worker kills itself
      when that parent is gone, so a run whose parent died never leaves workers behind), then sets strict mode
      for its own scope, whichever entry script loaded the modules: the
      test scopes chain to that scope, so every test body runs strict
      ([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) — the module code under
      test is strict through its own module scope. It then imports vendored Pester — resolved inside the worker,
      after the import, from the worker's own code root (Get-CatzcModulesRoot/.vendor/Pester), so Pester always
      comes from the tree the worker loaded
      ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)) — builds its
      run configuration through the ONE shared builder
      (New-PesterRunConfiguration, reached via module scope — the same builder Invoke-TestFile uses, so the
      worker and manual paths cannot drift), runs the shard's test files with the run's exclude tags, writes
      Pester's NUnit results to results-shard-<N>.xml, reduces its live result to rows (ConvertTo-
      TestAutomationRowSet — tier/category resolution needs the live .Block chain, so it must happen inside the
      worker) into rows-shard-<N>.json, writes each test file's whole Pester duration (set-up included) into
      files-shard-<N>.json — the measurement the next run schedules by (Select-TestShardAssignment) — with the
      file's own Result and ErrorMessage (the error of a file that failed while Pester discovered or set it up,
      which no test row can carry; empty when the file loaded), and
      exits 0 (green) or 1 (the run did not pass — failed tests, or a
      container/discovery error that fails the run with zero failed tests). Any other exit code — or a missing
      rows sidecar — means the worker itself crashed, which the parent surfaces loudly.
    parameters:
      ShardIndex: The shard's zero-based index — names the script, results, and rows files.
      TestPath: The shard's test files (absolute *.Tests.ps1 paths).
      RunDirectory: The run directory the script and its artifacts are written into (must exist).
      ExcludeTag: Tags excluded from the worker's run (from Get-TestExcludeTag). Empty means no tag filter.
      IncludeTag: Tags a test must carry to run (the -Rule provenance filter). Empty means no include filter.
      Verbosity: Pester output verbosity inside the worker (the run's -Output value).
      FullNameFilter: |-
        Filter the worker's run to tests whose full name contains this text — the manual single-check path
        (Invoke-TestFile). Empty means no name filter (the harness never sets one).
      EntryScript: |-
        The run seam ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)): the script the
        worker dot-sources to load the modules. Empty (the
        default) is the source run's `<repo>/importer.ps1 -SkipJanitors`; the build run passes the build's
        `Import-Catzc.ps1`. Everything after the load — Pester from the code root, the shared configuration
        builder, the row sidecar — is identical for both runs, except that the configuration hands the entry script
        to the Go bridge, so the Go tests start the same engine the worker loaded.
      EntryParameter: |-
        Named arguments for -EntryScript, rendered into the dot-source line as `-Name 'value'` (a $true value
        renders as a bare switch). Ignored without -EntryScript. The build run passes
        @{ RepositoryRoot = <repo> } so out/ and repo-relative paths keep resolving in the repository.
      LanguageExecutable: |-
        The managed tool per test language and the executable per engine other than pwsh the run's source session
        located (Get-LanguageTestExecutable: @{ go = <path>; python = <uv path>; <engine> = <path> }), rendered into the
        worker as a hashtable literal and handed through the configuration to the language bridge; an empty entry means
        there is none. The worker never locates a tool: a build's engine has no tools.yml entry.
    outputs: '[pscustomobject] with ShardIndex, Label, ScriptPath, ResultsPath, RowsPath, FilesPath.'
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
