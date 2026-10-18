<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/Get-AzureCustomer.ps1
    name: get-azure-customer
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
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
