<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Reports/Clear-Output.ps1
    kind: public-function
    module: Catzc.Base.Reports
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN#1
      - ADR-REPO-OUTDIR#7
---
#>

<#
.SYNOPSIS
    Removes the output that output-formats.yml no longer keeps: old run stamps, stale session files, superseded builds.
.DESCRIPTION
    Each format's area sets how many stamps or files stay and how old they may grow; a file no format covers is reported, never removed.
.PARAMETER All
    Remove everything under the output root but its .gitkeep, whatever the formats keep.
.PARAMETER DryRun
    Report what would be removed without removing anything.
.PARAMETER PassThru
    Return { Removed; Uncovered; UnitCount; DryRun } instead of only the removed paths.
.OUTPUTS
    [string[]] the output-root-relative paths removed (or, under -DryRun, that would be); with -PassThru, the result object.
.EXAMPLE
    Clear-Output -DryRun
.EXAMPLE
    Clear-Output -All
#>
function Clear-Output {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $All,

        [switch] $DryRun,

        [switch] $PassThru
    )

    $outputRoot = Get-OutputRoot
    $uncovered = @()
    $unitCount = 0
    if (-not (Test-Path -LiteralPath $outputRoot -PathType Container)) {
        $remove = @()
    }
    elseif ($All) {
        $remove = @(Get-ChildPath $outputRoot -Depth 1 -Exclude @() -PruneVendor $false |
                ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                Where-Object { $_ -ne '.gitkeep' } |
                Sort-Object)
    }
    else {
        $files = foreach ($path in Get-ChildPath $outputRoot -Depth 12 -File -Exclude @() -PruneVendor $false) {
            $relative = [System.IO.Path]::GetRelativePath($outputRoot, $path).Replace('\', '/')
            [Catzc.Base.Reports.OutputFile]::new($relative, [System.IO.File]::GetLastWriteTimeUtc($path))
        }
        $pipeline = (Get-RunEnvironment) -eq 'Pipeline'
        $plan = [Catzc.Base.Reports.OutputRetention]::Plan([Catzc.Base.Reports.OutputFile[]] @($files), (Get-Config -Config output-formats),
            [datetime]::UtcNow, $pipeline)
        $remove = @($plan.Remove)
        $uncovered = @($plan.Uncovered)
        $unitCount = $plan.UnitCount
    }

    foreach ($relative in $remove) {
        if (-not $DryRun) {
            Remove-Item -LiteralPath (Join-Path $outputRoot $relative) -Recurse -Force
        }
    }
    $verb = if ($DryRun) {
        'would remove'
    }
    else {
        'removed'
    }
    Write-Message "Clear-Output: $verb $($remove.Count) output path(s); $($uncovered.Count) file(s) no format covers"

    if ($PassThru) {
        return [pscustomobject]@{
            Removed   = [string[]] $remove
            Uncovered = [string[]] $uncovered
            UnitCount = $unitCount
            DryRun    = [bool] $DryRun
        }
    }
    [string[]] $remove
}
