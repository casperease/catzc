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
