<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Environment/Add-PermanentPath.ps1
    name: add-permanent-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Environment
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-environment/Add-PermanentPath.ps1.md
    test: automation/Catzc.Base.Environment/tests/Add-PermanentPath.Tests.ps1
  config:
    synopsis: Adds a directory to PATH persistently and in the current session.
    description: |-
      Cross-platform PATH persistence:
      - Windows: writes to the User-scope registry PATH.
      - Linux/macOS: appends a marked block to the PowerShell profile.
      - Always: updates $env:PATH for the current session.

      Idempotent — skips if the path is already present.
    parameters:
      Path: The directory to add. Must exist.
      Prepend: Place the path at the beginning instead of the end.
      Label: |-
        Identity marker for Unix profile blocks. Defaults to the leaf folder name.
        Must match when calling Remove-PermanentPath.
      Sync: |-
        After adding, call Sync-SessionPath to merge any other new registry
        entries into the current session (Windows only).
    examples:
      - Add-PermanentPath '/usr/local/go/bin'
      - Add-PermanentPath $installDir -Prepend -Label 'Install-Dotnet'
      - Add-PermanentPath $toolDir -Sync
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
