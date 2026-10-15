<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Sync-SessionPath.ps1
    kind: public-function
    module: Catzc.Base.Environment
    visibility: public
    adrs:
      - ADR-AUTO-CONSOLE#11
  config:
    synopsis: Rebuilds the session PATH from the registry on Windows. No-op on Unix.
    description: |-
      Reads Machine and User PATH from the Windows registry and rebuilds
      $env:PATH. Registry entries form the base; session-only entries
      (e.g. from Add-PermanentPath or a tool's install script) are kept
      only if their directory still exists on disk.

      This handles both directions:
      - New entries added to the registry by an installer appear in the session.
      - Entries removed from the registry by an uninstaller disappear from
        the session (even if the directory still exists on disk).

      On Linux/macOS this function is a no-op — package managers update PATH
      through profile scripts that take effect on next shell launch.
    examples:
      - Sync-SessionPath
---
#>

function Sync-SessionPath {
    param()

    if (-not $IsWindows) {
        return
    }

    # Read the persistent PATH through the seam (Get-EnvironmentPath) so tests Mock it instead of the registry.
    $machinePath = Get-EnvironmentPath -Scope Machine
    $userPath = Get-EnvironmentPath -Scope User
    $registryPaths = ($userPath, $machinePath | ForEach-Object { $_ -split ';' }) |
        Where-Object { $_ -ne '' }

    # Build the set of all registry entries (normalized for dedup)
    $registrySet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($p in $registryPaths) {
        $registrySet.Add($p.TrimEnd('\', '/')) | Out-Null
    }

    # Keep session-only entries only if they still exist on disk
    $currentPaths = $env:PATH -split ';' | Where-Object { $_ -ne '' }
    $kept = foreach ($p in $currentPaths) {
        $normalized = $p.TrimEnd('\', '/')
        if ($registrySet.Contains($normalized)) {
            $p
        }
        elseif (Test-Path $p) {
            $p
        }
    }

    # Add any registry entries not yet in the session @ so an empty $kept yields an empty array, not $null (HashSet's...
    # [comment:4](/docs/references/automation/catzc-base-environment/Sync-SessionPath.ps1.md#comment4)
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [string[]]@($kept | ForEach-Object { $_.TrimEnd('\', '/') }),
        [System.StringComparer]::OrdinalIgnoreCase
    )
    $newPaths = foreach ($p in $registryPaths) {
        if ($seen.Add($p.TrimEnd('\', '/'))) {
            $p
        }
    }

    # Rewrite the session PATH only when an entry arrives or leaves, and say which — on a clean devbox nothing...
    # [comment:5](/docs/references/automation/catzc-base-environment/Sync-SessionPath.ps1.md#comment5)
    $added = @($newPaths)
    $dropped = @($currentPaths | Where-Object { $_ -notin @($kept) })
    if ($added.Count -or $dropped.Count) {
        $env:PATH = (@($kept) + $added) -join ';'
        $change = @(
            if ($added.Count) {
                "added from the registry '$($added -join "', '")'"
            }
            if ($dropped.Count) {
                "dropped missing '$($dropped -join "', '")'"
            }
        )
        Write-Message "Session PATH: $($change -join '; ')"
    }
}
