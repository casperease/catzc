<#
.SYNOPSIS
    The psscriptanalyzer formatter engine: formats the given PowerShell files with the vendored analyzer's
    Invoke-Formatter and the .editorconfig rules, and returns the files it changed.
.DESCRIPTION
    Invoke-Formatter ignores .editorconfig, so line endings, trailing space and the final newline are a second step.
    [ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2),
    [ADR-REPO-FORMAT#3](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format3),
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md#comment1)
.PARAMETER File
    Absolute paths of the PowerShell files to format.
.PARAMETER DryRun
    List the files that would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-PSScriptAnalyzerFormat {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The shard worker''s analyzer import runs inside each background Start-Job process, never in this session')]
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'

    # The one per-file step, run in this session or, source-copied, in a shard process.
    $formatFiles = {
        param([string[]] $Files, [string] $Settings, [bool] $Preview)
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        foreach ($path in $Files) {
            $original = [System.IO.File]::ReadAllText($path)
            $text = Invoke-Formatter -ScriptDefinition $original -Settings $Settings
            $text = $text -replace "`r`n", "`n"         # end_of_line = lf
            $text = $text -replace '(?m)[ \t]+$', ''    # trim_trailing_whitespace = true
            $text = $text.TrimEnd("`n") + "`n"          # insert_final_newline = true
            # -cne: PowerShell's -ne is case-insensitive, so a casing-only change would otherwise look unchanged.
            if ($text -cne $original) {
                if (-not $Preview) {
                    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
                }
                $path
            }
        }
    }

    # A cold pass spends about 40 ms a file resolving command names it has not seen, so a large batch is sharded...
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md#comment3)
    $shardCount = [Math]::Min([Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 4)), [int][Math]::Floor($File.Count / 25))
    if ($shardCount -lt 2) {
        if (-not (Get-Module PSScriptAnalyzer)) {
            # Without this line the several-second vendored analyzer import would look like a hang.
            # [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)
            # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md#comment2)
            Write-Message 'Loading PSScriptAnalyzer (first use this session)...'
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }
        return , [string[]] @(& $formatFiles $File $settingsPath ([bool] $DryRun))
    }

    $shards = @{}
    for ($i = 0; $i -lt $shardCount; $i++) {
        $shards[$i] = [System.Collections.Generic.List[string]]::new()
    }
    for ($i = 0; $i -lt $File.Count; $i++) {
        $shards[$i % $shardCount].Add($File[$i])
    }
    $worker = {
        param($shardFiles, $root, $analyzer, $settings, $preview, $source)
        Import-Module $analyzer -Force
        Push-Location $root
        $ProgressPreference = 'SilentlyContinue'
        try {
            & ([scriptblock]::Create($source)) $shardFiles $settings $preview
        }
        finally {
            Pop-Location
        }
    }
    $analyzerPath = Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer'
    $jobs = for ($i = 0; $i -lt $shardCount; $i++) {
        Start-Job -ScriptBlock $worker -ArgumentList @($shards[$i].ToArray(), (Get-RepositoryRoot), $analyzerPath, $settingsPath, [bool] $DryRun, $formatFiles.ToString())
    }
    try {
        $null = $jobs | Wait-Job
        $changedSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($job in $jobs) {
            # A failed shard would silently drop its files' changes, so fail loudly.
            if ($job.State -ne 'Completed') {
                throw "PSScriptAnalyzer format shard job $($job.Id) ended in state '$($job.State)': $(($job.ChildJobs.JobStateInfo.Reason.Message) -join '; ')"
            }
            foreach ($path in @(Receive-Job -Job $job -ErrorAction Stop)) {
                [void] $changedSet.Add([string] $path)
            }
        }
    }
    finally {
        $jobs | Remove-Job -Force
    }

    , [string[]] @($File | Where-Object { $changedSet.Contains($_) })
}
