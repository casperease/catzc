<#
.SYNOPSIS
    Removes vendored modules from automation/.vendor, validating first that each is restorable from the source.
.DESCRIPTION
    Doubles as the "committed binaries are available on the network" check. For every targeted vendored module
    it queries the configured source (configs/vendor.yml) for its committed version:

    - Without -Force it changes nothing: it reports each target, whether the source can restore it, and the
      exact recreate command — a dry run.
    - With -Force it deletes each target's automation/.vendor/<Name> folder, but only after confirming every
      target is restorable. If any is NOT available on the source, it refuses the whole run (deleting would be
      irreversible) — so a removal is always reversible, whether by Install-VendorModule or `git restore`.

    A PR that strips vendored binaries (to slim the repo, leaning on the source) runs this to prove the set is
    reproducible before deleting.
.PARAMETER Name
    Vendored module names to target. Defaults to every vendored module.
.PARAMETER Force
    Actually delete. Without it the command is a dry run (report + recreate recipe).
.EXAMPLE
    Remove-VendorModules
.EXAMPLE
    Remove-VendorModules -Name Pester -Force
#>
function Remove-VendorModules {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name,

        [switch] $Force
    )

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
