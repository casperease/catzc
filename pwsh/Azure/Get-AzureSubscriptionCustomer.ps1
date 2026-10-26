function Get-AzureSubscriptionCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Subscription
    )

    if ($Subscription.Contains('customer')) {
        return $Subscription.customer
    }
    ''
}
