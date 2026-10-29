# pwsh/Azure.Templates/Get-BicepResourceName.ps1

<!-- cspell:ignore deweuzctsmplst -->

The function that generates an Azure resource name for a template's slot from the naming standard, delegating the rendering to
`Get-AzureResourceName`.

## help

### synopsis

Generates an Azure resource name for a template's slot from the naming standard.

### description

The templating-layer name generator. It resolves the name components from the template and environment, then assembles the name for the
requested resource type via Get-AzureResourceName:

- env — the environment NAME (generous types) and its 2-char shortcode (restricted)
- slot — the optional special-slot discriminator (`-Slot`)
- region_code — the environment's azure.yml region_code
- org — azure.yml top-level org
- short_name — the template's options.yml short_name
- order — the active naming order (Get-Naming; the naming repo-wide variant)

The caller supplies only what is genuinely per-call: the resource Type and optional Customer / Role. The name it returns is the one injected
into the built parameter files (the PrePost seam); a name is derived, never typed into a config, so there is nothing to compare it against.

### parameter `Template`

Template name.

### parameter `Environment`

Environment shortname.

### parameter `Type`

Resource-type abbreviation — a key of Get-AzureResourceTypeSet (`rg`, `st`, `kv`, ...).

### parameter `Slot`

Optional special-slot discriminator; omitted selects the env's base / index-0 slot.

### parameter `Customer`

Optional customer, named by its key OR its 2-char shortcode (customer.yml). Its readable key renders in generous names and its 2-char
shortcode in restricted ones — both resolved here (Get-AzureCustomer) and passed to the namer.

### parameter `Role`

Optional 2-3 char sibling discriminator among same-type resources (per resource).

### example 1

```powershell
Get-BicepResourceName -Template sample -Environment dev -Type st   # -> deweuzctsmplst
```

### example 2

```powershell
Get-BicepResourceName -Template sample-indexed -Environment dev -Slot 001 -Type rg
# -> dev-001-weu-zct-sidx-rg
```

## Identity, not subscription

Naming needs only the environment's identity (its shortcode and region code), never a subscription, so the function reads `azure.yml`
directly and is independent of the subscription group and the customer. The subscription group is a resolution axis only and is never a name
component
([ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-subscriptionnotcomponent)).

## Forms passed to the namer

The namer picks the environment form by pattern, the name for the generous patterns and the shortcode for the restricted ones, and the
environment and the slot are separate segments. The function passes both forms and the slot and lets the namer choose.

The customer may be given by key or by its 2-character shortcode. `Get-AzureCustomer` resolves it from `customer.yml` to the canonical key
and shortcode, and throws on an unknown token. The key renders in the generous patterns and the shortcode in the restricted ones.
