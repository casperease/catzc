<#
.SYNOPSIS
    Resolves a marker's declared verify scope (globs.yml `verify:`) into Test-Automation's run parameters.
.DESCRIPTION
    The -Marker resolver: looks the named globset up in the registry (an unknown name throws there,
    naming the config) and returns its `verify:` scope — the modules whose tests verify a change in that
    area-of-control, and the tier to run them through (the blast-radius marker role, ADR-GLOBS:7). A
    marker without a verify scope throws with the remedy: declare one in globs.yml.
.PARAMETER Name
    The globset name (globs.yml).
.OUTPUTS
    [pscustomobject] with Modules (string[]) and Level (int 0-3).
#>
function Resolve-MarkerVerify {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    $set = Get-GlobSet -Name $Name
    if ($set.VerifyModules.Count -eq 0) {
        throw "Globset '$Name' declares no verify scope — add 'verify: { modules: [...], level: N }' to it in globs.yml to run its blast radius (ADR-GLOBS:7)."
    }

    [pscustomobject]@{
        Modules = @($set.VerifyModules)
        Level   = $set.VerifyLevel
    }
}
