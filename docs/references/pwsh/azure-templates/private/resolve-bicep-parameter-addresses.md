# pwsh/Azure.Templates/private/Resolve-BicepParameterAddresses.ps1

The private function that resolves the config-addressed entries of a template config's parameters into ARM `value` entries.

## help

### synopsis

Resolves the config-addressed entries of a template config's parameters into ARM `value` entries.

### description

A parameter in a template config's `ParametersFile.parameters` takes one of three forms: a literal `{ value: … }`, an ARM Key Vault
`{ reference: … }`, or a config address `{ address: global.<config>.<key>… }`
([ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress)). This resolves every address
through Get-ConfigValue
([ADR-CONF-ADDRESSING-GLOBALADDRESSFORM](../../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-globaladdressform))
and returns the parameters with each addressed entry replaced by `{ value: <resolved node> }`; every other entry passes through unchanged,
in its order.

An address reaches only version-controlled config
([ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY](../../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-versioncontrolledonly)),
so no secret can be addressed: a secure parameter takes a Key Vault reference, never an address.

Fails fast, with every violation in one throw that names the config file and each parameter: an entry that sets `address` together with
`value` or `reference` (or any other key), an address that is not a string, and an address that does not resolve (an unknown config, a
missing key, or a malformed address).

### parameter `Parameters`

The `ParametersFile.parameters` map of one template config, as parsed from its YAML.

### parameter `ConfigFile`

The config file the parameters come from, named in every violation.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` the parameters, with every address resolved to a value.

### example 1

```powershell
Resolve-BicepParameterAddresses -Parameters $configuration.ParametersFile.parameters -ConfigFile $configFile
# { enforcementMode: { address: global.azure.policy_enforcement.production } } -> { enforcementMode: { value: Default } }
```
