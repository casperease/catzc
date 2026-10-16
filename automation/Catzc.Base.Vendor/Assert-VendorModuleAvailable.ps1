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
  config:
    synopsis: Asserts a module (optionally at a specific version) is available from the configured vendor source.
    description: |-
      The throwing half of the restorability check (Test-VendorModuleAvailable is the query). Throws an
      actionable error when the source cannot offer the module, so a caller — chiefly Remove-VendorModules — never
      deletes a committed binary that the network cannot restore.
    parameters:
      Name: The module name that must be available on the source.
      Version: An optional exact version that must be available.
    examples:
      - Assert-VendorModuleAvailable -Name Pester -Version '5.5.0'
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
