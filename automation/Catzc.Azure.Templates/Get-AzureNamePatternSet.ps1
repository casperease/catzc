<#
.SYNOPSIS
    The three Azure resource-name patterns the generator (Get-AzureResourceName) renders.
.DESCRIPTION
    Every resource type (Get-AzureResourceTypeSet) ties to exactly one pattern via its `pattern`
    property. A pattern is the recipe for turning the name components into a name — it fixes BOTH the
    render separator AND the length budget (a restriction is length as much as format, not just the
    missing hyphens):
      long    — hyphen-separated, generous: length does NOT bind, so the type carries its own `limit`
                (rg 90, waf 128, …). Most resources.
      kv      — hyphen-separated like `long`, but length-restricted to 24 (the key-vault class: a
                hyphenated name where 24 actually binds — customer+role can overflow it).
      storage — tight: segments concatenated (NO separator) → lowercase alphanumeric only, capped 24.
      vm      — the same tight (concatenated) render as `storage`, capped at 15 (Windows computer-name).

    `kv`, `storage`, `vm` are the restricted archetypes — each carries an intrinsic binding `limit`,
    and only `long` types may use a widened 5-char `type` abbreviation. `long` has no intrinsic limit,
    so each long type supplies its own (generous, non-binding) Azure max.
.EXAMPLE
    (Get-AzureNamePatternSet).storage   # -> @{ separator = ''; limit = 24 }
#>
function Get-AzureNamePatternSet {
    param()

    [ordered]@{
        long    = @{ separator = '-' }              # hyphenated, generous — length doesn't bind; type carries its own limit
        kv      = @{ separator = '-'; limit = 24 }  # hyphenated but length-restricted (key-vault class: 24, binds)
        storage = @{ separator = ''; limit = 24 }   # tight (concatenated, no hyphens), 24
        vm      = @{ separator = ''; limit = 15 }   # same tight render as storage, capped at the Windows computer-name 15
    }
}
