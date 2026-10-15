<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Remove-PermanentPath.ps1
    kind: automation-function
    module: Catzc.Base.Environment
    visibility: public
    adrs:
      - ADR-PWSH-DRYRUN#1
  config:
    synopsis: Removes a directory from PATH persistently and in the current session.
    description: |-
      Cross-platform PATH removal:
      - Windows: removes from the User-scope registry PATH.
      - Linux/macOS: removes the marked block from the PowerShell profile.
      - Always: removes from $env:PATH for the current session.

      Idempotent — no error if the path is not present.
    parameters:
      Path: The directory to remove.
      Label: |-
        Identity marker for Unix profile blocks. Must match the label used
        when Add-PermanentPath was called. Defaults to the leaf folder name.
      Sync: |-
        After removing, call Sync-SessionPath to refresh the session PATH
        from the registry (Windows only).
    examples:
      - Remove-PermanentPath '/usr/local/go/bin'
      - Remove-PermanentPath $installDir -Label 'Install-Dotnet'
---
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

    # --- Persistent PATH --- Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests...
    # [comment:5](/docs/references/automation/catzc-base-environment/Remove-PermanentPath.ps1.md#comment5)
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
