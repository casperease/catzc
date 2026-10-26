<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-environment/Add-PermanentPath.ps1.md"
  header: "generated"
---
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
    $normalizedPath = $Path.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)

    # --- Session PATH ---
    $entries = $env:PATH -split [regex]::Escape($separator) | Where-Object { $_ -ne '' }
    $comparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparer]::Ordinal
    }
    $alreadyInSession = $entries | Where-Object {
        $comparer.Equals($_.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
                [System.IO.Path]::AltDirectorySeparatorChar), $normalizedPath)
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

    # The persistent PATH goes through a thin read and write seam, so a test stands in for it and never touches the machine's.
    if ($IsWindows) {
        $userPath = Get-EnvironmentPath -Scope User
        $userEntries = @(if ($userPath) {
                $userPath -split ';' | Where-Object { $_ -ne '' }
            }
            else {
                @()
            })
        $alreadyPersisted = $userEntries | Where-Object {
            $comparer.Equals($_.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
                    [System.IO.Path]::AltDirectorySeparatorChar), $normalizedPath)
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
