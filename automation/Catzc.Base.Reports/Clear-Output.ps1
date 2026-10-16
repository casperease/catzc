<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Reports/Clear-Output.ps1
    name: clear-output
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Reports
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    cites:
      - ADR-AUTO-DRYRUN#1
      - ADR-REPO-OUTDIR#7
  config:
    synopsis: 'Removes the output that output-formats.yml no longer keeps: old run stamps, stale session files, superseded builds.'
    description: |-
      Each format's area sets how many stamps or files stay and how old they may grow; a file no format covers is
      reported, never removed.
    parameters:
      All: |-
        Remove everything under the output root but its .gitkeep and the plan files, which cannot be regenerated,
        whatever the formats keep.
      DryRun: Report what would be removed without removing anything.
      PassThru: Return { Removed; Uncovered; UnitCount; DryRun } instead of only the removed paths.
    outputs: '[string[]] the output-root-relative paths removed (or, under -DryRun, that would be); with -PassThru, the result object.'
    examples:
      - Clear-Output -DryRun
      - Clear-Output -All
---
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
                Where-Object { $_ -ne '.gitkeep' -and $_ -notlike 'plan-*.md' } |
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
