<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureCustomer.ps1
    kind: automation-function
    module: Catzc.Azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
  config:
    synopsis: Resolves a customer reference (its key OR its shortcode) to the canonical customer record.
    description: |-
      A customer is named two ways — its readable key (apex) or its 2-char shortcode (ap). A subscription's
      `customer` field in azure.yml may use either; this resolves both to the same record so downstream code
      always works with the canonical key. Reads customer.yml (Get-Config -Config customer). The key/shortcode
      name-spaces are kept distinct by the CustomerConfig type, so the match is unambiguous: keys first, then
      shortcodes. Throws when the token is neither.
    parameters:
      Name: A customer key or shortcode.
    outputs: 'An ordered dictionary: @{ key; shortcode; details }.'
    examples:
      - '(Get-AzureCustomer apex).key   # -> apex'
      - '(Get-AzureCustomer ap).key     # -> apex  (resolved by shortcode)'
---
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
