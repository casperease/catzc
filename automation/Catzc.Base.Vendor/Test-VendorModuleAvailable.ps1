<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/Test-VendorModuleAvailable.ps1
    kind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Vendor
    visibility: public
    relatives:
      test: automation/Catzc.Base.Vendor/tests/Test-VendorModuleAvailable.Tests.ps1
  config:
    synopsis: Tests whether a module (optionally at a specific version) is available from the configured vendor source.
    description: |-
      Queries the vendor source (configs/vendor.yml — PSGallery by default) with Find-PSResource. The querying
      half of the "committed binaries are restorable from the network" check; Remove-VendorModules uses it before
      deleting a vendored module, and it stands alone to validate a vendored set is reproducible.
    parameters:
      Name: The module name to look for on the source.
      Version: An optional exact version. Omit to test whether any version is available.
    outputs: '[bool] $true when the source offers the module (at the version, if given).'
    examples:
      - Test-VendorModuleAvailable -Name Pester -Version '5.5.0'
---
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
