function Measure-ImportFileProbe {
    [CmdletBinding()]
    [OutputType([System.Nullable[int]])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    # A probe that cannot run is null: an import never fails for its own record.
    try {
        $sw = [Diagnostics.Stopwatch]::StartNew()
        $folder = $null
        foreach ($candidate in [System.IO.Directory]::EnumerateDirectories($ModulesRoot)) {
            if (-not [System.IO.Path]::GetFileName($candidate).StartsWith('.')) {
                $folder = $candidate
                break
            }
        }
        if ($null -eq $folder) {
            return $null
        }
        $read = 0
        foreach ($file in [System.IO.Directory]::EnumerateFiles($folder, '*.ps1')) {
            [void] [System.IO.File]::ReadAllBytes($file)
            $read++
            if ($read -ge 20) {
                break
            }
        }
        [int] [math]::Round($sw.Elapsed.TotalMilliseconds)
    }
    catch {
        $null
    }
}
