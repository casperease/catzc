# pwsh/Azure.Templates/Get-AzureResourceTypeSet.ps1

The function that returns the Azure resource-type registry `Get-AzureResourceName` reads.

## help

### synopsis

Returns the Azure resource-type registry used by Get-AzureResourceName.

### description

It reads the `types` of `pwsh/Azure.Templates/configs/resource-types.yml`, typed by `ResourceTypesConfig`. Each entry is keyed by its ident,
the `<type>` segment of a resource name, and its line holds only what differs from the defaults declared on the type (pattern `long`,
charset `[a-z0-9-]`); the readable name of the type is the line's comment. An entry's fields:

```text
pattern — 'long' (hyphenated, generous), 'kv' (hyphenated but capped 24), 'storage'
          (tight/concatenated, capped 24), or 'vm' (tight like storage, capped 15), one of
          the patterns of the same file (Get-AzureNamePatternSet). The pattern fixes the
          render separator AND the length budget; the restricted patterns carry their cap.
limit   — for `long`-pattern types, the per-type Azure max (rg 90, waf 128, sqldb 128, …);
          kv/storage/vm take their cap from the pattern.
charset — the characters a name of the type may hold, when narrower than the default
          (st: [a-z0-9]).
omit    — optional; component names this type drops from its render (e.g. `vm` drops
          org/customer/role to fit 15 — the resource group already encodes them). `type` is
          never omitted.
```

The `type` segment is 2-5 chars (see [ADR-AZ-NAMING](../../../drs/azure/azure-naming-standard.md)); the widened 5-char form is only for
`long` types — the restricted `storage`/`vm` patterns keep a short 2-4 char abbreviation.

A new type is a line in the config
([ADR-AZ-NAMING-PATTERNPERRESOURCETYPE](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-patternperresourcetype)).

### example 1

```powershell
(Get-AzureResourceTypeSet).st   # -> @{ pattern = 'storage'; charset = '[a-z0-9]' }
```
