<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
---
#>

<#
.SYNOPSIS
    Deletes the contents of the user's temp folder(s).
.DESCRIPTION
    Safe to re-run: entries locked by a running process are skipped, never an error, and the folders themselves stay.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment1)
.PARAMETER Path
    Defaults to the de-duplicated user temp locations; pass a path to target one specific folder instead.
    [comment:2](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment2)
.PARAMETER DryRun
    Removed counts every top-level entry as deleted, since a lock shows only on a real delete attempt.
    [comment:3](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment3)
.EXAMPLE
    Clear-TempFolders
    Clears the current user's temp folder(s).
.EXAMPLE
    Clear-TempFolders -DryRun
    Reports what would be removed (in the returned summary's Removed count) without deleting anything.
#>
function Clear-TempFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Path = @($env:TEMP, $env:TMP, [System.IO.Path]::GetTempPath()),

        [switch] $DryRun
    )

    $folders = $Path |
        Where-Object { $_ } |
        ForEach-Object { $_.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) } |
        Select-Object -Unique

    $totalRemoved = 0
    $totalSkipped = 0
    foreach ($folder in $folders) {
        if (-not [System.IO.Directory]::Exists($folder)) {
            Write-Verbose "Temp folder not found, skipping: $folder"
            continue
        }

        # .NET, not Remove-Item: its per-item cmdlet overhead over tens of thousands of entries costs minutes.
        # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment4)
        $removed = 0
        $skipped = 0
        foreach ($file in [System.IO.Directory]::GetFiles($folder)) {
            if ($DryRun) {
                $removed++; continue
            }
            try {
                [System.IO.File]::Delete($file); $removed++
            }
            catch {
                $skipped++; Write-Verbose "Skipped (in use): $file"
            }
        }
        foreach ($dir in [System.IO.Directory]::GetDirectories($folder)) {
            if ($DryRun) {
                $removed++; continue
            }
            try {
                [System.IO.Directory]::Delete($dir, $true); $removed++
            }
            catch {
                $skipped++; Write-Verbose "Skipped (in use): $dir"
            }
        }

        $verb = if ($DryRun) {
            'Would clear'
        }
        else {
            'Cleared'
        }
        Write-Message "$verb temp '$folder' — removed $removed, skipped $skipped (in use)"
        $totalRemoved += $removed
        $totalSkipped += $skipped
    }

    [pscustomobject]@{
        Removed = $totalRemoved
        Skipped = $totalSkipped
        Folders = @($folders)
    }
}
