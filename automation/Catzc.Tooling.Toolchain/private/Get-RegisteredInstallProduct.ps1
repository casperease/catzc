<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Get-RegisteredInstallProduct.ps1
    kind: private-function
    module: Catzc.Tooling.Toolchain
    visibility: private
    adrs:
      - ADR-AUTO-REMOVE#7
---
#>

<#
.SYNOPSIS
    Lists the Windows-registered products (Apps & features entries) that own an install folder.
.DESCRIPTION
    Matched by DisplayName because MSI and bundle products often lack an InstallLocation; entries differ by ProductCode.
.PARAMETER NamePattern
    A regular expression the product's DisplayName must match.
.OUTPUTS
    [pscustomobject] @{ DisplayName; DisplayVersion; ProductCode; Kind; UninstallCommand }, sorted by DisplayName.
#>
function Get-RegisteredInstallProduct {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoUnboundedEnumeration', '', Justification = 'It lists the registry provider (HKLM Uninstall keys), not the filesystem; the path sits in a variable the rule cannot read')]
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
            if (-not $entry) {
                continue
            }
            # One registry value as a string; '' when the entry does not carry it (strict-mode safe).
            $value = {
                param($property)
                if ($entry.PSObject.Properties[$property]) {
                    "$($entry.$property)"
                }
                else {
                    ''
                }
            }
            $name = & $value 'DisplayName'
            if (-not $name -or $name -notmatch $NamePattern) {
                continue
            }

            $code = $key.PSChildName
            $quietUninstall = & $value 'QuietUninstallString'
            $uninstall = $quietUninstall ? $quietUninstall : (& $value 'UninstallString')
            $kind = 'Other'
            if ((& $value 'BundleCachePath') -or (& $value 'BundleUpgradeCode')) {
                $kind = 'Bundle'
            }
            elseif ((& $value 'WindowsInstaller') -eq '1') {
                $kind = 'Msi'
                $uninstall = "msiexec /x $code /qn /norestart"
            }

            [pscustomobject]@{
                DisplayName      = $name
                DisplayVersion   = & $value 'DisplayVersion'
                ProductCode      = $code
                Kind             = $kind
                UninstallCommand = $uninstall
            }
        }
    }
    @($products) | Sort-Object ProductCode -Unique | Sort-Object DisplayName, Kind
}
