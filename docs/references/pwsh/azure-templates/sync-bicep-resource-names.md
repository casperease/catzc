# pwsh/Azure.Templates/Sync-BicepResourceNames.ps1

The function that writes every resource name of a template's slots into the slot configs, in full and in the configured order
([ADR-AZ-NAMING-DETERMINISTICNAMES](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames)).

## help

### synopsis

Writes each slot's resource names, its resource group and its option values into the slot configs, in the configured naming order.

### description

For each yml slot of each template, the names the template's `options.yml` derives (`names:`) are written under their parameters as
`{ value: <name> }`, and the items of a list or object of names keep the slot's own fields beside them. A ResourceGroup-target slot gets a
top-level `ResourceGroup: <name>` before `ParametersFile:`
([ADR-AZ-DATAMOD-DECLAREDGROUPNAME](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-declaredgroupname)). The options' `facts:`
and `addresses:` entries become slot values, `{ fact: <field> }` and `{ address: <global address> }`
([ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress)); a slot that sets the parameter
already keeps its own. Once every slot of a template is written, `names:`, `facts:` and `addresses:` leave its `options.yml`, with the
comment lines right above them.

A name the slot already declares, every string leaf under a parameter whose key ends in `Name` or `Names` and the top-level `ResourceGroup`,
is matched by ConvertFrom-AzureResourceName under the configured order and then under every other known order, and rendered again under the
configured one by Get-AzureResourceName. So after a change of the `naming` variant a second run rewrites every name in the new order
([ADR-AZ-NAMING-ORDERISVARIANT](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-orderisvariant)). A parameter with a
`naming_exception` is kept as written
([ADR-AZ-NAMING-EXCEPTIONENTRY](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-exceptionentry)), and a name with no single
match under any order is kept and named in a message.

The files are edited as text: a parameter block is replaced or appended under `parameters:`, and every other line, its comments and its
order stay as they are. A `.bicepparam` slot is skipped. A run that changes nothing writes nothing.

### parameter `Template`

The templates to sync, by name. Default: every template.

### example 1

```powershell
Sync-BicepResourceNames -Template discovery -WhatIf
```

### example 2

```powershell
Sync-BicepResourceNames
# after naming: classic in the variants overlay, every declared name is written type first
```
