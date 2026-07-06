<#
.SYNOPSIS
    Returns one subscription family by name — derived membership plus any declared configuration.
.DESCRIPTION
    A by-name lookup over Get-AzureFamilies (the single family map). Throws on an unknown family,
    naming the valid ones — never a silent empty result. See docs/adr/azure/data-model.md.
.PARAMETER Family
    Family name — a customer key, a subscription's explicit `family:` key, or an ungrouped
    subscription's own name.
.OUTPUTS
    An ordered dictionary: @{ name; customer; details; subscriptions }.
.EXAMPLE
    (Get-AzureFamily apex).subscriptions      # -> apex_nonprod, apex_prod
.EXAMPLE
    (Get-AzureFamily shared).customer         # -> ''  (a non-customer family)
#>
function Get-AzureFamily {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-AzureFamilies) | ForEach-Object { $_.name } })]
        [string] $Family
    )

    $families = Get-AzureFamilies
    $found = @($families | Where-Object { $_.name -ceq $Family })
    Assert-True ($found.Count -eq 1) -ErrorText "Unknown family '$Family' — not a derived or declared subscription family (valid: $(@($families | ForEach-Object { $_.name } | Sort-Object) -join ', '))"
    $found[0]
}
