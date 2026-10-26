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

    # Wrapped in @() so an empty set of kept entries is an empty array, which the set's constructor accepts where it rejects null.
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [string[]]@($kept | ForEach-Object { $_.TrimEnd('\', '/') }),
        [System.StringComparer]::OrdinalIgnoreCase
    )
    $newPaths = foreach ($p in $registryPaths) {
        if ($seen.Add($p.TrimEnd('\', '/'))) {
            $p
        }
    }

    # Rewritten and announced only when an entry arrives or leaves, so a settled machine imports in silence.
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
