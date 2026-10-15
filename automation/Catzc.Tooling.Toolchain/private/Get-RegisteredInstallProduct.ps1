<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Get-RegisteredInstallProduct.ps1
    kind: automation-function
    module: Catzc.Tooling.Toolchain
    visibility: private
    relatives:
      test: automation/Catzc.Tooling.Toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1
    adrs:
      - ADR-AUTO-REMOVE#7
  config:
    synopsis: Lists the Windows-registered products (Apps & features entries) that own an install folder.
    description: |-
      Reads the machine-wide uninstall registry (64- and 32-bit views) and returns the entries whose DisplayName
      matches -NamePattern — an MSI/bundle install such as the .NET SDK registers its products there, and often
      without an InstallLocation, so the name is the reliable key. An install those products own must be removed by
      the mechanism that placed it; deleting its folder by hand orphans every entry
      ([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)).

      Each entry says what kind of installer placed it and carries the command that removes it by that mechanism:
        - Bundle: an installer bundle (a Burn bundle — it registers BundleCachePath / BundleUpgradeCode, usually in the
          32-bit view only). It installed MSI products and holds them as their dependent, so they go only when the
          bundle does; its own quiet uninstall command removes it with them.
        - Msi: a Windows Installer product, removed with `msiexec /x <ProductCode>`. While a bundle holds it, msiexec
          reports success and removes nothing — uninstall the bundle first.
        - Other: any other installer, removed with its registered (quiet) uninstall string.
      A bundle and the MSI it installs often share a DisplayName, so entries are distinct by ProductCode, never by name.
      Windows only; elsewhere it returns nothing.
    parameters:
      NamePattern: A regular expression the product's DisplayName must match.
    outputs: '[pscustomobject] @{ DisplayName; DisplayVersion; ProductCode; Kind; UninstallCommand }, sorted by DisplayName.'
---
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
