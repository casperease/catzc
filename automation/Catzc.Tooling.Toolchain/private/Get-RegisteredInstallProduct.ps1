<#
.SYNOPSIS
    Lists the Windows-registered products (Apps & features entries) that own an install folder.
.DESCRIPTION
    Reads the machine-wide uninstall registry (64- and 32-bit views) and returns the entries whose DisplayName
    matches -NamePattern — an MSI/bundle install such as the .NET SDK registers its products there, and often
    without an InstallLocation, so the name is the reliable key. An install those products own must be removed by
    the mechanism that placed it (winget / Apps & features); deleting its folder by hand orphans every entry
    ([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)).
    Windows only; elsewhere it returns nothing.
.PARAMETER NamePattern
    A regular expression the product's DisplayName must match.
.OUTPUTS
    [pscustomobject] @{ DisplayName; DisplayVersion; ProductCode }, sorted by DisplayName.
#>
function Get-RegisteredInstallProduct {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $NamePattern
    )

    if (-not $IsWindows) {
        return
    }
    $roots = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    $products = foreach ($root in $roots) {
        foreach ($key in @(Get-ChildItem -LiteralPath $root -ErrorAction Ignore)) {
            $entry = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction Ignore
            $name = ''
            if ($entry -and $entry.PSObject.Properties['DisplayName']) {
                $name = "$($entry.DisplayName)"
            }
            if ($name -and $name -match $NamePattern) {
                $version = ''
                if ($entry.PSObject.Properties['DisplayVersion']) {
                    $version = "$($entry.DisplayVersion)"
                }
                [pscustomobject]@{
                    DisplayName    = $name
                    DisplayVersion = $version
                    ProductCode    = $key.PSChildName
                }
            }
        }
    }
    @($products) | Sort-Object DisplayName -Unique
}
