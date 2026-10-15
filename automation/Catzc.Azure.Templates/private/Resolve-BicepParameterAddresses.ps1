<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
    adrs:
      - ADR-AZ-DATAMOD#10
      - ADR-CONF-ADDRESSING#1
      - ADR-CONF-ADDRESSING#3
---
#>

<#
.SYNOPSIS
    Resolves the config-addressed entries of a template config's parameters into ARM `value` entries.
.DESCRIPTION
    An address reaches only version-controlled config, so a secure parameter takes a reference, never an address.
.PARAMETER Parameters
    The `ParametersFile.parameters` map of one template config, as parsed from its YAML.
.PARAMETER ConfigFile
    The config file the parameters come from, named in every violation.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] the parameters, with every address resolved to a value.
.EXAMPLE
    Resolve-BicepParameterAddresses -Parameters $configuration.ParametersFile.parameters -ConfigFile $configFile
    # { enforcementMode: { address: global.azure.policy_enforcement.production } } -> { enforcementMode: { value: Default } }
#>
function Resolve-BicepParameterAddresses {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Parameters,

        [Parameter(Mandatory)]
        [string] $ConfigFile
    )

    $resolved = [ordered]@{}
    $violations = [System.Collections.Generic.List[string]]::new()

    foreach ($name in @($Parameters.Keys)) {
        $entry = $Parameters[$name]
        if ($entry -isnot [System.Collections.IDictionary] -or -not $entry.Contains('address')) {
            $resolved[$name] = $entry
            continue
        }

        $otherKeys = @(foreach ($key in $entry.Keys) {
                if ($key -ne 'address') {
                    $key
                }
            })
        if ($otherKeys.Count -gt 0) {
            $violations.Add("parameter '$name' sets 'address' together with '$($otherKeys -join "', '")' — an addressed parameter sets 'address' alone")
            continue
        }

        $address = $entry['address']
        if ($address -isnot [string] -or [string]::IsNullOrWhiteSpace($address)) {
            $violations.Add("parameter '$name' has an 'address' that is not a global config address string (global.<config>.<key>…)")
            continue
        }

        try {
            $value = Get-ConfigValue -Address $address
        }
        catch {
            $violations.Add("parameter '$name' has address '$address', which does not resolve: $($_.Exception.Message)")
            continue
        }
        $resolved[$name] = [ordered]@{ value = $value }
    }

    if ($violations.Count -gt 0) {
        throw "Template config '$ConfigFile' has invalid config-addressed parameters:`n  - $($violations -join "`n  - ")"
    }

    $resolved
}
