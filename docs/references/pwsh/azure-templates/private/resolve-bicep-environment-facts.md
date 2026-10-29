# pwsh/Azure.Templates/private/Resolve-BicepEnvironmentFacts.ps1

A private helper of Get-BicepPreparedConfiguration. It resolves each slot parameter that names its value by a fact, `{ fact: <field> }`
(ADR-AZ-DATAMOD-VALUEBYFACT), from the slot's azure.yml coordinate, so a slot never writes the value itself.

## help

### synopsis

Resolves the fact parameters of a slot to their values.

### description

Each parameter whose entry is `{ fact: <field> }` becomes `{ value: <resolved> }`; every other entry passes through unchanged.
`module_resource_types` is the types the shared modules declare (Get-BicepModuleResourceTypes). `subscription_production`,
`policy_enforcement` and `groups` follow the class of the slot's subscription: a subscription that holds a production environment is
production. `groups` is the group of each role of the slot's owner in that class, empty when none. Any other field is a boolean field of the
slot's environment, such as `production`. A set with no fact reads no config. A fact set together with another key, or naming an unknown
field, throws naming the config file, the parameter and the field; so does a slot whose environment or subscription azure.yml does not
declare.

Private helper of Get-BicepPreparedConfiguration; not exported.

### parameter `Parameters`

The slot's parameter entries, after its addresses are resolved.

### parameter `Slot`

The slot the facts are resolved for.

### parameter `ConfigFile`

The slot config file the parameters come from, named in every error.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` Parameter name to entry, each fact entry replaced by its value entry.

### example 1

```powershell
Resolve-BicepEnvironmentFacts -Parameters $parameters -Slot $slot -ConfigFile $configFile
```
