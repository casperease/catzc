<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Vendor/Assert-VendorModuleAvailable.ps1
    name: assert-vendor-module-available
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Vendor/tests/Assert-VendorModuleAvailable.Tests.ps1
---
#>

function Assert-VendorModuleAvailable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [string] $Version
    )

    if (-not (Test-VendorModuleAvailable -Name $Name -Version $Version)) {
        $where = "source '$(Resolve-VendorRepository)'"
        $what = if ($Version) {
            "'$Name' v$Version"
        }
        else {
            "'$Name'"
        }
        throw "Vendor module $what is not available from $where — it cannot be restored from the network."
    }
}
