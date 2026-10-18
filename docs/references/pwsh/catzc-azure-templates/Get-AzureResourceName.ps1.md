# pwsh/Catzc.Azure.Templates/Get-AzureResourceName.ps1

<!-- cspell:ignore weuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Assembles a deterministic Azure resource name from the standard component set.

### description

Resolves the component VALUES (env, slot, region, org, short_name, `[customer]`, `[role]`, type) and arranges them per the selected order
from Get-AzureNameOrderSet:

```text
standard — <env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>
classic  — <type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]
```

The env-segment value is chosen by the type's pattern: generous (`long`) types render the readable env NAME (-Env); restricted
(`kv`/`storage`/`vm`) types render the 2-char SHORTCODE (-Shortcode), so a long name never costs a tight name a byte. `env` and `slot` are
separate segments; segments are joined by the pattern's render separator (a hyphen for `long`/`kv`, nothing for `storage`/`vm` —
Get-AzureNamePatternSet). Every component is format-validated (case-sensitive, lowercase). The assembled name is asserted against the type's
limit; on overflow it throws, naming the components to shorten. Names are deterministic — no random suffixes.

### parameter `Env`

Environment name (azure.yml env key, e.g. `develop`). The env-segment of generous (`long`) types.

### parameter `Shortcode`

2-letter environment shortcode (azure.yml env `shortcode`, e.g. `de`). The env-segment of the restricted patterns; required when Type is
restricted.

### parameter `RegionCode`

3-letter region code (azure.yml env `region_code`, e.g. `weu`).

### parameter `Org`

Vertical/organization shortcode (azure.yml top-level `org`, 2-3 alnum).

### parameter `ShortName`

Template id segment (options.yml `short_name`, 2-5 alnum, globally unique).

### parameter `Type`

Resource-type abbreviation — a key of Get-AzureResourceTypeSet (`rg`, `st`, `kv`, …).

### parameter `Slot`

Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …).

### parameter `Customer`

Optional customer / sub-tenant. The readable key (the customer-segment of generous `long` types).

### parameter `CustomerShortcode`

2-letter customer shortcode (azure.yml customer `shortcode`). The customer-segment of the restricted patterns; required when both -Customer
is set and Type is restricted.

### parameter `Role`

Optional 2-3 char sibling discriminator among same-type resources (per resource).

### parameter `Order`

Name component order — a key of Get-AzureNameOrderSet (default `standard`).

### example 1

```powershell
Get-AzureResourceName -Env develop -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type rg
# -> develop-001-weu-zct-smpl-rg
```

### example 2

```powershell
Get-AzureResourceName -Env develop -Shortcode de -Slot 001 -RegionCode weu -Org zct -ShortName smpl -Type st
# -> de001weuzctsmplst
```

## comment:1

Above `$omit = if ($specification.Contains('omit')) {`, written with `#`.

```text
A type may omit components from its render — e.g. the Windows `vm` (15-char cap) drops
org/customer/role, which the resource group already encodes (see
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). The `type`
segment is never omitted.
```

## comment:2

Above `$envValue = if ($specification.pattern -eq 'long') {`, written with `#`.

```text
The env-segment is the readable name for the generous `long` pattern, the 2-char shortcode for
the restricted patterns (kv/storage/vm) — see
[ADR-AZ-NAMING-PATTERNPERRESOURCETYPE](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming-patternperresourcetype).
```

## comment:3

Above `$customerValue = ''`, written with `#`.

```text
Customer follows the same pattern-chosen split as env: the readable key (-Customer) for the
generous `long` pattern, the 2-char shortcode (-CustomerShortcode) for the restricted patterns.
Only applies when a customer is given (the segment is optional).
```

## comment:4

Above `$checks = [ordered]@{`, written with `#`.

```text
Component format checks (case-sensitive, lowercase) — see
[ADR-AZ-NAMING-LOWERCASECOMPONENTS](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents).
```
