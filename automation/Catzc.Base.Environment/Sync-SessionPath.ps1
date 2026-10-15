# catzc:
#   path: automation/Catzc.Base.Environment/Sync-SessionPath.ps1
#   module: Catzc.Base.Environment
#   visibility: public

<#
.SYNOPSIS
    Rebuilds the session PATH from the registry on Windows. No-op on Unix.
.DESCRIPTION
    Registry entries win: a session-only entry survives only while its directory exists, so uninstalled tools drop out.
    [comment:1](/docs/references/automation/catzc-base-environment/Sync-SessionPath.ps1.md#comment1)
.EXAMPLE
    Sync-SessionPath
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

    # The @() wrap keeps an empty $kept an array, because the HashSet constructor rejects a null collection.
    # [comment:2](/docs/references/automation/catzc-base-environment/Sync-SessionPath.ps1.md#comment2)
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [string[]]@($kept | ForEach-Object { $_.TrimEnd('\', '/') }),
        [System.StringComparer]::OrdinalIgnoreCase
    )
    $newPaths = foreach ($p in $registryPaths) {
        if ($seen.Add($p.TrimEnd('\', '/'))) {
            $p
        }
    }

    # Rewriting only on a real change keeps the import quiet on a clean devbox, where nothing arrives or leaves.
    # [ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)
    # [comment:3](/docs/references/automation/catzc-base-environment/Sync-SessionPath.ps1.md#comment3)
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
