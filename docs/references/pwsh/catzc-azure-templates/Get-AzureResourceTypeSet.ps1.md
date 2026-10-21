# pwsh/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the Azure resource-type registry used by Get-AzureResourceName.

### description

Each entry is keyed by its name abbreviation (the `<type>` segment of a resource name) and ties to one of four render/constraint patterns
(Get-AzureNamePatternSet):

```text
pattern — 'long' (hyphenated, generous), 'kv' (hyphenated but capped 24), 'storage'
          (tight/concatenated, capped 24), or 'vm' (tight like storage, capped 15). The pattern
          fixes the render separator AND the length budget — restriction is length as much as
          format. The restricted patterns (kv/storage/vm) carry an intrinsic binding cap.
limit   — required only for `long`-pattern types (generous, per-type Azure max: rg 90, waf 128,
          sqldb 128, …); kv/storage/vm take their cap from the pattern.
omit    — optional; component names this type drops from its render (e.g. `vm` drops
          org/customer/role to fit 15 — the resource group already encodes them). `type` is
          never omitted.
```

The `type` segment is 2-5 chars (see [ADR-AZ-NAMING](../../../drs/azure/azure-naming-standard.md)); the widened 5-char form is only for
`long` types — the restricted `storage`/`vm` patterns keep a short 2-4 char abbreviation.

Starter set from
[ADR-AZ-NAMING-PATTERNPERRESOURCETYPE](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-patternperresourcetype) — extend as
the consuming repos need.

### example 1

```powershell
(Get-AzureResourceTypeSet).st   # -> @{ pattern = 'storage' }
```
