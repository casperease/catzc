<#
.SYNOPSIS
    Returns every subscription family — the derived groupings plus any declared family configuration.
.DESCRIPTION
    Builds the full family map from azure.yml: every subscription is grouped by its derived family
    (Get-AzureSubscriptionFamily — the single derivation), and the optional top-level `families:` map
    overlays configuration onto the matching entries. Sensible defaults mean a family needs no
    declaration to exist; a declared entry only adds configuration (see docs/adr/azure/data-model.md).
.OUTPUTS
    One ordered dictionary per family: @{ name; customer; details; subscriptions } — `customer` is the
    canonical customer key ('' for a non-customer family), `details` is the declared free text (''),
    `subscriptions` the member subscription names.
.EXAMPLE
    Get-AzureFamilies | ForEach-Object { $_.name }        # -> apex, flux, itsm, nova, ortho_main, shared
.EXAMPLE
    (Get-AzureFamilies | Where-Object { $_.name -eq 'apex' }).subscriptions   # -> apex_nonprod, apex_prod
#>
function Get-AzureFamilies {
    [CmdletBinding()]
    param()

    $azure = Get-Config -Config azure

    $members = [ordered]@{}
    foreach ($subscriptionName in @($azure.subscriptions.Keys)) {
        $family = Get-AzureSubscriptionFamily $subscriptionName
        if (-not $members.Contains($family)) {
            $members[$family] = [System.Collections.Generic.List[string]]::new()
        }
        $members[$family].Add($subscriptionName)
    }

    $ret = [System.Collections.Generic.List[object]]::new()
    foreach ($family in @($members.Keys)) {
        $customerKeys = @($members[$family] | ForEach-Object {
                Get-AzureSubscriptionCustomer $azure.subscriptions[$_]
            } | Where-Object { $_ } | ForEach-Object { (Get-AzureCustomer $_).key } | Select-Object -Unique)
        $declared = if ($azure.Contains('families') -and $azure.families.Contains($family)) {
            $azure.families[$family]
        }
        else {
            $null
        }
        $details = if ($null -ne $declared -and $declared.Contains('details')) {
            "$($declared.details)"
        }
        else {
            ''
        }
        $customer = if ($customerKeys.Count -gt 0) {
            $customerKeys[0]
        }
        else {
            ''
        }
        $ret.Add([ordered]@{
                name          = $family
                customer      = $customer
                details       = $details
                subscriptions = $members[$family].ToArray()
            })
    }
    , $ret.ToArray()
}
