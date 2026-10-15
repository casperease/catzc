# catzc:
#   path: automation/Catzc.Base.ConfigExtensions/Invoke-ConfigValidator.ps1
#   module: Catzc.Base.ConfigExtensions
#   visibility: public

<#
.SYNOPSIS
    Validates a parsed config with a PowerShell validator, run in the owning module's scope.
.DESCRIPTION
    Runs in the owning module, so a private validator works; a missing conventional one is silent, a named one throws.
    [comment:1](/docs/references/automation/catzc-base-configextensions/Invoke-ConfigValidator.ps1.md#comment1)
.PARAMETER Config
    The parsed config (e.g. ConvertFrom-Yaml -Ordered output).
.PARAMETER Name
    The config's kebab-case name, without the .yml extension.
.PARAMETER Module
    The module that owns the config and its validator.
.PARAMETER Validator
    A validator function name to use instead of the conventional one.
.OUTPUTS
    [string] The name of the validator that ran; nothing when no conventional validator exists.
.EXAMPLE
    Invoke-ConfigValidator -Config $parsed -Name widget -Module TstWidget
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
