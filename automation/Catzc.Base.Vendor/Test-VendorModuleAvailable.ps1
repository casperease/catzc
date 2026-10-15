<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/Test-VendorModuleAvailable.ps1
    kind: function
    module: Catzc.Base.Vendor
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether a module (optionally at a specific version) is available from the configured vendor source.
.DESCRIPTION
    The query half of the restorability check: Remove-VendorModules asks it before deleting a vendored module.
.PARAMETER Name
    The module name to look for on the source.
.PARAMETER Version
    An optional exact version. Omit to test whether any version is available.
.OUTPUTS
    [bool] $true when the source offers the module (at the version, if given).
.EXAMPLE
    Test-VendorModuleAvailable -Name Pester -Version '5.5.0'
#>
function Test-VendorModuleAvailable {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [string] $Version
    )

    $findParams = @{
        Name        = $Name
        Repository  = (Resolve-VendorRepository)
        ErrorAction = 'SilentlyContinue'
    }
    if ($Version) {
        $findParams.Version = $Version
    }

    [bool] (Find-PSResource @findParams)
}
