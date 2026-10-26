function Remove-PermanentPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Does not use ShouldProcess by design — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $Label = (Split-Path $Path -Leaf),

        [switch] $Sync
    )

    $separator = [System.IO.Path]::PathSeparator
    $normalizedPath = $Path.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)

    # --- Session PATH ---
    $comparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparer]::Ordinal
    }
    $kept = ($env:PATH -split [regex]::Escape($separator) |
            Where-Object {
                $_ -ne '' -and -not $comparer.Equals(
                    $_.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar),
                    $normalizedPath)
            }) -join $separator
    if ($kept -ne $env:PATH) {
        $env:PATH = $kept
        Write-Message "Session PATH: removed '$Path'"
    }

    # The persistent PATH goes through a thin read and write seam, so a test stands in for it and never touches the machine's.
    if ($IsWindows) {
        $userPath = Get-EnvironmentPath -Scope User
        if ($userPath) {
            $cleaned = ($userPath -split ';' |
                    Where-Object {
                        $_ -ne '' -and -not $comparer.Equals(
                            $_.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
                                [System.IO.Path]::AltDirectorySeparatorChar),
                            $normalizedPath)
                    }) -join ';'
            Set-EnvironmentPath $cleaned -Scope User
        }
    }
    else {
        $profilePath = $PROFILE.CurrentUserCurrentHost
        if (Test-Path $profilePath) {
            $content = Get-Content $profilePath -Raw
            $startMarker = ">>> catzc PATH $Label >>>"
            $endMarker = "<<< catzc PATH $Label <<<"
            $cleaned = $content -replace "(?s)\r?\n?# $([regex]::Escape($startMarker)).*?# $([regex]::Escape($endMarker))\r?\n?", ''
            if ($cleaned -ne $content) {
                Set-Content -Path $profilePath -Value $cleaned -NoNewline
                Write-Message "Profile '$profilePath': removed the PATH block '$Label'"
            }
        }
    }

    if ($Sync) {
        Sync-SessionPath
    }
}
