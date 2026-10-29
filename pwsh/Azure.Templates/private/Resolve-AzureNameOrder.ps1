function Resolve-AzureNameOrder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object] $Order
    )

    if ($Order -is [string]) {
        $orders = Get-AzureNameOrderSet
        Assert-True $orders.Contains($Order) -ErrorText "Unknown name order '$Order' (known: $(@($orders.Keys) -join ', '))"
        return , $orders[$Order]
    }
    , @(@($Order) | ForEach-Object { , @([string] $_) })
}
