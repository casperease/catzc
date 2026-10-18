<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1
    folder: private
    name: invoke-ps-script-analyzer-format
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
    page: docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md
    cites:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CONSOLE#10
      - ADR-PRIN-CONFIG#2
      - ADR-REPO-FORMAT#3
---
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

    $shardCount = [Math]::Min([Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 4)), [int][Math]::Floor($File.Count / 25))
    if ($shardCount -lt 2) {
        if (-not (Get-Module PSScriptAnalyzer)) {
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
