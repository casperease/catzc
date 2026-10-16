<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
    folder: private
    name: resolve-bicep-parameter-addresses
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
    adrs:
      - ADR-AZ-DATAMOD#10
      - ADR-CONF-ADDRESSING#{1,3}
  config:
    synopsis: Resolves the config-addressed entries of a template config's parameters into ARM `value` entries.
    description: |-
      A parameter in a template config's `ParametersFile.parameters` takes one of three forms: a literal
      `{ value: … }`, an ARM Key Vault `{ reference: … }`, or a config address `{ address: global.<config>.<key>… }`
      ([ADR-AZ-DATAMOD#10](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10)). This resolves every address
      through Get-ConfigValue
      ([ADR-CONF-ADDRESSING#1](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing1)) and
      returns the parameters with each addressed entry replaced by `{ value: <resolved node> }`; every other entry
      passes through unchanged, in its order.

      An address reaches only version-controlled config
      ([ADR-CONF-ADDRESSING#3](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing3)), so no
      secret can be addressed: a secure parameter takes a Key Vault reference, never an address.

      Fails fast, with every violation in one throw that names the config file and each parameter: an entry that
      sets `address` together with `value` or `reference` (or any other key), an address that is not a string, and
      an address that does not resolve (an unknown config, a missing key, or a malformed address).
    parameters:
      Parameters: The `ParametersFile.parameters` map of one template config, as parsed from its YAML.
      ConfigFile: The config file the parameters come from, named in every violation.
    outputs: '[System.Collections.Specialized.OrderedDictionary] the parameters, with every address resolved to a value.'
    examples:
      - |-
        Resolve-BicepParameterAddresses -Parameters $configuration.ParametersFile.parameters -ConfigFile $configFile
        # { enforcementMode: { address: global.azure.policy_enforcement.production } } -> { enforcementMode: { value: Default } }
---
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
