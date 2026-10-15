<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureCustomer.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
---
#>

<#
.SYNOPSIS
    Resolves a customer reference (its key OR its shortcode) to the canonical customer record.
.DESCRIPTION
    Keys match before shortcodes, and a token that is neither throws, so callers always get the canonical key.
    [comment:1](/docs/references/automation/catzc-azure/Get-AzureCustomer.ps1.md#comment1)
.PARAMETER Name
    A customer key or shortcode.
.OUTPUTS
    An ordered dictionary: @{ key; shortcode; details }.
.EXAMPLE
    (Get-AzureCustomer apex).key   # -> apex
.EXAMPLE
    (Get-AzureCustomer ap).key     # -> apex  (resolved by shortcode)
#>
function Get-AzureCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config customer).customers.Keys })]
        [string] $Name
    )

    $customer = Get-Config -Config customer
    $customers = $customer.customers

    $key = $null
    if ($customers.ContainsKey($Name)) {
        $key = $Name
    }
    else {
        foreach ($candidate in $customers.Keys) {
            if ($customers[$candidate].shortcode -ceq $Name) {
                $key = $candidate
                break
            }
        }
    }

    Assert-True ($null -ne $key) -ErrorText "Unknown customer '$Name' — not a customer key or shortcode in customer.yml (valid keys: $(@($customers.Keys) -join ', '))"

    $entry = $customers[$key]
    [ordered]@{ key = $key; shortcode = $entry.shortcode; details = "$($entry.details)" }
}
