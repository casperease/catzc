<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-config-extensions/Invoke-ConfigValidator.ps1.md"
  header: "generated"
---
#>

function Invoke-ConfigValidator {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $Config,

        [Parameter(Mandatory)]
        [ValidatePattern('(?-i)^[a-z0-9]+(-[a-z0-9]+)*$')]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Module,

        [string] $Validator
    )

    $owner = Get-Module $Module
    if (-not $owner) {
        throw "Config '$Name': owning module '$Module' is not loaded."
    }

    $explicit = [bool] $Validator
    $function = if ($explicit) {
        $Validator
    }
    else {
        Get-ConfigValidatorName -Name $Name
    }

    $found = & $owner { param($fn) [bool](Get-Command $fn -CommandType Function -ErrorAction Ignore) } $function
    if (-not $found) {
        if ($explicit) {
            throw "Config '$Name': validator '$function' is not defined in module '$Module'."
        }
        return
    }

    Write-Verbose "Validating config '$Name' with $function in $Module"
    $null = & $owner { param($fn, $c) & $fn $c } $function $Config
    $function
}
