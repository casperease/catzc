# pwsh/Azure.Templates/Get-AzureNamePatternSet.ps1

The function that returns the four Azure resource-name patterns the generator, `Get-AzureResourceName`, renders.

## help

### synopsis

The four Azure resource-name patterns the generator (Get-AzureResourceName) renders.

### description

Every resource type (Get-AzureResourceTypeSet) ties to exactly one pattern via its `pattern` property. A pattern is the recipe for turning
the name components into a name — it fixes BOTH the render separator AND the length budget (a restriction is length as much as format, not
just the missing hyphens):

```text
long    — hyphen-separated, generous: length does NOT bind, so the type carries its own `limit`
          (rg 90, waf 128, …). Most resources.
kv      — hyphen-separated like `long`, but length-restricted to 24 (the key-vault class: a
          hyphenated name where 24 actually binds — customer+role can overflow it).
storage — tight: segments concatenated (NO separator) → lowercase alphanumeric only, capped 24.
vm      — the same tight (concatenated) render as `storage`, capped at 15 (Windows computer-name).
```

`kv`, `storage`, `vm` are the restricted archetypes — each carries an intrinsic binding `limit`, and only `long` types may use a widened
5-char `type` abbreviation. `long` has no intrinsic limit, so each long type supplies its own (generous, non-binding) Azure max.

### example 1

```powershell
(Get-AzureNamePatternSet).storage   # -> @{ separator = ''; limit = 24 }
```
