<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vendor/Test-VendorModuleAvailable.ps1.md"
  warning: "Generated Header"
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
