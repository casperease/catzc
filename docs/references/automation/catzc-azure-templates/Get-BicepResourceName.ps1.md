# automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1

<!-- cspell:ignore deweuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
- order — the active naming order (Get-AdoNaming; the ado_naming repo-wide variant)

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

## comment:1

Above `$envEntry = $azure.environments[$Environment]`, written with `#`.

```text
Naming needs only the environment's IDENTITY (shortcode/region_code), never a subscription — so it
reads azure.yml directly and is independent of subscription group/customer. The subscription group
is a resolution axis only and is never a name component
([ADR-AZ-NAMING#8](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming8)).
```

## comment:2

Above `$nameArgs = @{`, written with `#`.

```text
The namer picks the env form by pattern (name for generous, shortcode for restricted); env and
slot are separate segments. We pass both forms + the slot and let it choose.
```

## comment:3

Above `$resolvedCustomer = Get-AzureCustomer $Customer`, written with `#`.

```text
Resolve the customer (given by key OR 2-char shortcode) to its canonical key + shortcode from
customer.yml: the readable key renders in generous patterns, the 2-char shortcode in the
restricted ones (the namer picks per type). Get-AzureCustomer throws on an unknown token.
```
