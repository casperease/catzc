<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Remove-PermanentPath.ps1
    kind: function
    module: Catzc.Base.Environment
    visibility: public
    adrs:
      - ADR-PWSH-DRYRUN#1
---
#>

<#
.SYNOPSIS
    Removes a directory from PATH persistently and in the current session.
.DESCRIPTION
    Removes from the User registry PATH on Windows and the marked profile block on Unix; an absent path is no error.
.PARAMETER Path
    The directory to remove.
.PARAMETER Label
    Must equal the Label Add-PermanentPath was given, or no block matches and nothing is removed.
.PARAMETER Sync
    Rebuilds the session PATH from the registry, so entries other tools changed are picked up too; Windows only.
.EXAMPLE
    Remove-PermanentPath '/usr/local/go/bin'
.EXAMPLE
    Remove-PermanentPath $installDir -Label 'Install-Dotnet'
#>
function Remove-PermanentPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not use ShouldProcess by design — see ADR-PWSH-DRYRUN#1')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $Label = (Split-Path $Path -Leaf),

        [switch] $Sync
    )

    $separator = [System.IO.Path]::PathSeparator
    $normalizedPath = $Path.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

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

    # The registry goes through Get-/Set-EnvironmentPath so tests mock them and never touch the real machine PATH.
    # [comment:4](/docs/references/automation/catzc-base-environment/Remove-PermanentPath.ps1.md#comment4)
    if ($IsWindows) {
        $userPath = Get-EnvironmentPath -Scope User
        if ($userPath) {
            $cleaned = ($userPath -split ';' |
                    Where-Object {
                        $_ -ne '' -and -not $comparer.Equals(
                            $_.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar),
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
