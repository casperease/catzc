# pwsh/Azure.Templates/ConvertTo-BicepParam.ps1

The function that renders a slot's prepared configuration descriptor as Bicep's own parameters format, a `.bicepparam` text.

## help

### synopsis

Renders a slot's prepared configuration descriptor as Bicep's own parameters format, a .bicepparam text.

### description

The build's one path to the deploy
([ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-onepathtoparameters)): every slot becomes a
.bicepparam that bicep build-params compiles to the ARM parameters JSON. This renders a yml slot's ParametersFile.parameters after its
addresses resolve and its PrePost hook runs: a value becomes a Bicep literal and a Key Vault reference becomes az.getSecret(...), in the
layout bicep format leaves unchanged. The parameters pass through the same JSON the ARM parameters file is written as, so a typed config
record an address resolves to, or a hook's wrapped value, reaches the writer as exactly the data that JSON holds.

A descriptor with no ParametersFile.parameters fails with a named error.

### parameter `Descriptor`

The prepared configuration descriptor, holding ParametersFile.parameters.

### parameter `Using`

The using path: the template's main.bicep, relative to the folder the .bicepparam is written to.

### outputs

`[string]` the .bicepparam text.

### example 1

```powershell
ConvertTo-BicepParam -Descriptor $prepared -Using '../../infrastructure/templates/widget/main.bicep'
```
