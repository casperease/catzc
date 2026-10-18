function Remove-VendorModules {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name,

        [switch] $Force
    )

    Assert-SourceTree

    $targets = @(Get-VendoredModule)
    if ($Name) {
        $targets = @($targets | Where-Object { $_.Name -in $Name })
    }
    if ($targets.Count -eq 0) {
        Write-Message 'No vendored modules to remove.'
        return
    }

    # Which targets the source cannot restore — deleting these would be irreversible.
    $unavailable = @($targets | Where-Object { -not (Test-VendorModuleAvailable -Name $_.Name -Version $_.Version) })

    if (-not $Force) {
        Write-Message "Would remove $($targets.Count) vendored module(s) — pass -Force to delete:"
        foreach ($module in $targets) {
            $restorable = if ($module -in $unavailable) {
                'NOT on source — removal would be irreversible'
            }
            else {
                'restorable from source'
            }
            Write-Message "  $($module.Name) v$($module.Version) — $restorable"
            Write-Message "    recreate: Install-VendorModule '$($module.Name)' -RequiredVersion '$($module.Version)'  (or git restore)"
        }
        return
    }

    if ($unavailable.Count -gt 0) {
        $list = ($unavailable | ForEach-Object { "$($_.Name) v$($_.Version)" }) -join ', '
        throw "Refusing to remove — not available from the source, so deletion would be irreversible: $list. Restore from git or fix the vendor source, then retry."
    }

    foreach ($module in $targets) {
        Remove-Item -LiteralPath $module.Path -Recurse -Force
        Write-Message "Removed vendored module: $($module.Name) v$($module.Version)"
        Write-Message "  recreate with: Install-VendorModule '$($module.Name)' -RequiredVersion '$($module.Version)'  (or git restore)"
    }
}
