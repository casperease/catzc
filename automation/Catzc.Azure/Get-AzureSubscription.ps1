<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure/Get-AzureSubscription.ps1
    name: get-azure-subscription
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md
    test: automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
    cites:
      - ADR-AZ-CUSTOMER
      - ADR-AZ-DATAMOD#4
  config:
    synopsis: Returns the resolved Azure subscription identity (id + tenant [+ customer]) for a named subscription.
    description: |-
      Reads configs/azure.yml via Get-Config and looks up the subscription by name (a key in
      `subscriptions`) — the by-name identity lookup the resolved configuration coordinates and the session
      reverse lookup (Get-AzCliSessionSubscription) build on; there is no (environment, group, customer)
      join here. The matching tenant is looked up by name and embedded. A
      subscription MAY carry a `customer`, named by its key OR its 2-char shortcode (a customer in
      customer.yml); it is resolved to the canonical key and included (and renders into the resource names of
      anything deployed there). See [ADR-AZ-DATAMOD#4](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod4) and
      [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
    parameters:
      Subscription: Subscription name — a key in azure.yml's `subscriptions`.
    examples:
      - |-
        $sub = Get-AzureSubscription shared_nonprod
        $sub.id
        $sub.tenant.id
      - '(Get-AzureSubscription apex_nonprod).customer   # -> apex'
---
#>

function Get-AzureSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $azure = Get-Config -Config azure
    $found = $azure.subscriptions[$Subscription]
    Assert-True ($null -ne $found) -ErrorText "Unknown subscription '$Subscription' in azure.yml"
    Assert-True ($azure.tenants.ContainsKey($found.tenant)) -ErrorText "Subscription '$Subscription' references unknown tenant '$($found.tenant)'"

    $tenant = [Catzc.Azure.Tenant]::new($found.tenant, $azure.tenants[$found.tenant].id)
    $customerToken = Get-AzureSubscriptionCustomer $found
    $customer = if ([string]::IsNullOrEmpty($customerToken)) {
        ''
    }
    else {
        (Get-AzureCustomer $customerToken).key
    }
    [Catzc.Azure.AzureSubscription]::new($Subscription, $found.id, $customer, $tenant)
}
