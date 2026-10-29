function Get-BicepServiceConnectionName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config service-connections).identities.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config service-connections).identities.Keys })]
        [string] $Identity
    )

    $azure = Get-Config -Config azure
    $config = Get-Config -Config service-connections
    # The subscription's coordinates: its per-subscription environment (nsub, psub), that environment's region, and its customer.
    $environment = Get-AzureSubscriptionEnvironment -Subscription $Subscription
    $environmentEntry = $azure.environments[$environment]
    $nameArgs = @{
        Env        = $environment
        Shortcode  = $environmentEntry.shortcode
        RegionCode = $environmentEntry.region_code
        Org        = $azure.org
        ShortName  = $config.short_name
        Role       = $config.identities[$Identity].role
        Type       = 'sc'
        Order      = Get-Naming
    }
    $customer = (Get-AzureSubscription -Subscription $Subscription).customer
    if (-not [string]::IsNullOrEmpty($customer)) {
        $nameArgs['Customer'] = $customer
    }

    Get-AzureResourceName @nameArgs
}
