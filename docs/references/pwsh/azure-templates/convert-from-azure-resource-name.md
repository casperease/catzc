# pwsh/Azure.Templates/ConvertFrom-AzureResourceName.ps1

<!-- cspell:ignore weuzctsmplst -->

The function that matches a declared Azure resource name against the canonical form and returns its components
([ADR-AZ-NAMING-DETERMINISTICNAMES](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames)).

## help

### synopsis

Matches a declared Azure resource name against the canonical form and returns its components.

### description

A name is matched, never parsed: the `storage` and `vm` renders join their parts with no separator, so splitting a name is ambiguous. Every
part except the role comes from a known candidate set, and `AzureNameMatcher` renders each candidate combination through the one renderer
(`AzureNameRenderer`) under the order, with no length check. The leftover is the role, which must match `^[a-z][a-z0-9]{1,2}$`
([ADR-AZ-NAMING-LOWERCASECOMPONENTS](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents)).

Exactly one match returns the components, keyed `env`, `slot`, `region`, `org`, `short_name`, `customer`, `role` and `type`, with the
readable environment name and customer key whichever form the name renders. No match throws a diagnosis per part: the candidates it found in
the name, the ones it did not, and the leftover that is not a role. More than one match throws as ambiguous and lists every match.

### parameter `Name`

The declared name to match. Taken from the pipeline.

### parameter `Type`

The type ident the name must carry, a key of Get-AzureResourceTypeSet. Omitted, every registered type is tried.

### parameter `CandidateSet`

The known values of each part. `env` maps each environment name to its shortcode and `customer` each customer key to its shortcode, since
the type's pattern picks the form; `slot`, `region`, `org` and `short_name` are lists. A base slot and no customer are always candidates.
The type and pattern registries come from Get-AzureResourceTypeSet and Get-AzureNamePatternSet.

### parameter `Order`

Name component order, a key of Get-AzureNameOrderSet. Default: the naming variant (Get-Naming)
([ADR-AZ-NAMING-ORDERISVARIANT](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-orderisvariant)).

### example 1

```powershell
$sets = @{ env = @{ develop = 'de' }; region = @('weu'); org = @('zct'); short_name = @('smpl') }
ConvertFrom-AzureResourceName -Name de001weuzctsmplst -Type st -CandidateSet ($sets + @{ slot = @('001') })
# -> env develop, slot 001, region weu, org zct, short_name smpl, type st
```

## Omitted components

A component the type omits, such as the `vm`'s org, customer and role, renders nothing and is returned empty.
