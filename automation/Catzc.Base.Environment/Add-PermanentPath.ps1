<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Add-PermanentPath.ps1
    kind: function
    module: Catzc.Base.Environment
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Adds a directory to PATH persistently and in the current session.
.DESCRIPTION
    Windows persists in the User registry PATH, Unix in a marked profile block; a path already present is skipped.
.PARAMETER Path
    The directory to add. Must exist.
.PARAMETER Prepend
    Place the path at the beginning instead of the end.
.PARAMETER Label
    Must equal the Label given to Remove-PermanentPath, or that call cannot find the block to remove.
.PARAMETER Sync
    Also brings in registry entries that other installers added, not only this path; it has no effect on Unix.
.EXAMPLE
    Add-PermanentPath '/usr/local/go/bin'
.EXAMPLE
    Add-PermanentPath $installDir -Prepend -Label 'Install-Dotnet'
.EXAMPLE
    Add-PermanentPath $toolDir -Sync
#>
function Add-PermanentPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [switch] $Prepend,

        [string] $Label = (Split-Path $Path -Leaf),

        [switch] $Sync
    )

    Assert-PathExist $Path -PathType Container

    $separator = [System.IO.Path]::PathSeparator
    $normalizedPath = $Path.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

    # --- Session PATH ---
    $entries = $env:PATH -split [regex]::Escape($separator) | Where-Object { $_ -ne '' }
    $comparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparer]::Ordinal
    }
    $alreadyInSession = $entries | Where-Object {
        $comparer.Equals($_.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar), $normalizedPath)
    } | Select-Object -First 1

    if (-not $alreadyInSession) {
        if ($Prepend) {
            $env:PATH = "$Path$separator$env:PATH"
            Write-Message "Session PATH: prepended '$Path'"
        }
        else {
            $env:PATH = "$env:PATH$separator$Path"
            Write-Message "Session PATH: appended '$Path'"
        }
    }

    # The registry goes through Get-/Set-EnvironmentPath so tests mock them and never touch the real machine PATH.
    # [comment:4](/docs/references/automation/catzc-base-environment/Add-PermanentPath.ps1.md#comment4)
    if ($IsWindows) {
        $userPath = Get-EnvironmentPath -Scope User
        $userEntries = if ($userPath) {
            $userPath -split ';' | Where-Object { $_ -ne '' }
        }
        else {
            @()
        }
        $alreadyPersisted = $userEntries | Where-Object {
            $comparer.Equals($_.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar), $normalizedPath)
        } | Select-Object -First 1

        if (-not $alreadyPersisted) {
            if ($Prepend) {
                $userEntries = @($Path) + $userEntries
            }
            else {
                $userEntries = $userEntries + @($Path)
            }
            Set-EnvironmentPath ($userEntries -join ';') -Scope User
        }
    }
    else {
        $profilePath = $PROFILE.CurrentUserCurrentHost
        $startMarker = ">>> catzc PATH $Label >>>"
        $profileExists = Test-Path $profilePath
        $alreadyPatched = $profileExists -and (Get-Content $profilePath -Raw) -match [regex]::Escape($startMarker)

        if (-not $alreadyPatched) {
            $profileDir = Split-Path $profilePath -Parent
            if (-not (Test-Path $profileDir)) {
                New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
            }
            $pathLine = if ($Prepend) {
                "`$env:PATH = `"$Path$separator`$env:PATH`""
            }
            else {
                "`$env:PATH = `"`$env:PATH$separator$Path`""
            }
            $block = @"

# $startMarker
$pathLine
# <<< catzc PATH $Label <<<
"@
            Add-Content -Path $profilePath -Value $block
            Write-Message "Profile '$profilePath': added the PATH block '$Label' for '$Path'"
        }
    }

    if ($Sync) {
        Sync-SessionPath
    }
}
