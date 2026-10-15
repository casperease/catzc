<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/Invoke-ConfigValidator.ps1
    kind: automation-function
    module: Catzc.Base.ConfigExtensions
    visibility: public
  config:
    synopsis: Validates a parsed config with a PowerShell validator, run in the owning module's scope.
    description: |-
      The PowerShell extension point for config validation. Core configs validate through a C# config type
      registered in configs.yml (Get-Config); a config whose owner cannot ship a C# type validates here instead,
      with a PowerShell function that receives the parsed dictionary and throws on a violation.

      The validator is found by convention, Assert-<TitleCase(name)>Config (so 'widget-parts' is
      Assert-WidgetPartsConfig), or named with -Validator. It is resolved and run inside the owning module
      (`& (Get-Module $Module) { … }`), so a private validator works and the result is the same whichever module
      calls. With the conventional name and no such function, nothing runs and nothing is returned; a -Validator
      that does not exist throws.
    parameters:
      Config: The parsed config (e.g. ConvertFrom-Yaml -Ordered output).
      Name: The config's kebab-case name, without the .yml extension.
      Module: The module that owns the config and its validator.
      Validator: A validator function name to use instead of the conventional one.
    outputs: '[string] The name of the validator that ran; nothing when no conventional validator exists.'
    examples:
      - Invoke-ConfigValidator -Config $parsed -Name widget -Module TstWidget
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
