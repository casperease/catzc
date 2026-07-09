<#
.SYNOPSIS
    Returns the Azure resource-type registry used by Get-AzureResourceName.
.DESCRIPTION
    Each entry is keyed by its name abbreviation (the `<type>` segment of a resource name) and ties
    to one of three render/constraint patterns (Get-AzureNamePatternSet):
      pattern — 'long' (hyphenated, generous), 'kv' (hyphenated but capped 24), 'storage'
                (tight/concatenated, capped 24), or 'vm' (tight like storage, capped 15). The pattern
                fixes the render separator AND the length budget — restriction is length as much as
                format. The restricted patterns (kv/storage/vm) carry an intrinsic binding cap.
      limit   — required only for `long`-pattern types (generous, per-type Azure max: rg 90, waf 128,
                sqldb 128, …); kv/storage/vm take their cap from the pattern.
      omit    — optional; component names this type drops from its render (e.g. `vm` drops
                org/customer/role to fit 15 — the resource group already encodes them). `type` is
                never omitted.

    The `type` segment is 2-5 chars (see azure-naming-standard.md); the widened 5-char form is only for
    `long` types — the restricted `storage`/`vm` patterns keep a short 2-4 char abbreviation.

    Starter set from docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4 — extend as the consuming repos need.
.EXAMPLE
    (Get-AzureResourceTypeSet).st   # -> @{ pattern = 'storage' }
#>
function Get-AzureResourceTypeSet {
    param()

    [ordered]@{
        rg    = @{ pattern = 'long'; limit = 90 }   # resource group
        st    = @{ pattern = 'storage' }               # storage account (tight, no hyphens, 24)
        kv    = @{ pattern = 'kv' }                    # key vault — hyphenated but length-restricted to 24
        waf   = @{ pattern = 'long'; limit = 128 }  # web application firewall policy
        vnet  = @{ pattern = 'long'; limit = 64 }   # virtual network
        sql   = @{ pattern = 'long'; limit = 63 }   # SQL logical server (lowercase, hyphens ok)
        sqldb = @{ pattern = 'long'; limit = 128 }  # SQL database (5-char type ok — long pattern)
        vm    = @{ pattern = 'vm'; omit = @('org', 'customer', 'role') }  # virtual machine (15; omits RG-encoded segments to fit)
        synw  = @{ pattern = 'long'; limit = 50 }   # Synapse Analytics workspace
        adf   = @{ pattern = 'long'; limit = 63 }   # Data Factory (V2) — 3-63 chars
        log   = @{ pattern = 'long'; limit = 63 }   # Log Analytics workspace (4-63)
        nic   = @{ pattern = 'long'; limit = 80 }   # network interface
        pip   = @{ pattern = 'long'; limit = 80 }   # public IP address
    }
}
