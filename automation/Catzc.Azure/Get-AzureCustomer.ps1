<#
.SYNOPSIS
    Resolves a customer reference (its key OR its shortcode) to the canonical customer record.
.DESCRIPTION
    A customer is named two ways — its readable key (apex) or its 2-char shortcode (ap). A subscription's
    `customer` field in azure.yml may use either; this resolves both to the same record so downstream code
    always works with the canonical key. Reads customer.yml (Get-Config -Config customer). The key/shortcode
    name-spaces are kept distinct by Assert-CustomerConfig, so the match is unambiguous: keys first, then
    shortcodes. Throws when the token is neither.
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
    if ($customers.Contains($Name)) {
        $key = $Name
    }
    else {
        foreach ($candidate in $customers.Keys) {
            if ("$($customers[$candidate].shortcode)" -ceq $Name) {
                $key = $candidate
                break
            }
        }
    }

    Assert-True ($null -ne $key) -ErrorText "Unknown customer '$Name' — not a customer key or shortcode in customer.yml (valid keys: $(@($customers.Keys) -join ', '))"

    $entry = $customers[$key]
    $details = if ($entry.Contains('details')) {
        "$($entry.details)"
    }
    else {
        ''
    }
    [ordered]@{ key = $key; shortcode = "$($entry.shortcode)"; details = $details }
}
