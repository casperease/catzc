<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Vendor/Test-VendorModuleAvailable.ps1
    name: test-vendor-module-available
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Vendor/tests/Test-VendorModuleAvailable.Tests.ps1
    docs: "[Test-VendorModuleAvailable.ps1.md](docs/references/pwsh/catzc-base-vendor/Test-VendorModuleAvailable.ps1.md)"
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
