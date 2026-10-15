<#
.SYNOPSIS
    Deletes the contents of the user's temp folder(s).
.DESCRIPTION
    Removes every top-level entry from each temp folder, best-effort: a file or directory still in use by a running...
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment1)
.PARAMETER Path
    The temp folder(s) to clear.
    [comment:2](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment2)
.EXAMPLE
    Clear-TempFolders
    Clears the current user's temp folder(s).
.EXAMPLE
    Clear-TempFolders -DryRun
    Reports what would be removed (in the returned summary's Removed count) without deleting anything.
.PARAMETER DryRun
    Report what would be removed without deleting anything.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:3](/docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md#comment3)
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

        # Delete via.NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's per-item cmdlet...
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
