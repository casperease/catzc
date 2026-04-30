<#
.SYNOPSIS
    Returns the customer-class violations for a single resolved config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two never
    drift. Parallels Get-BicepConfigClassViolations. See docs/adr/azure/customer-model.md.
.DESCRIPTION
    Checks one config against the template's `customer_deployment` bit and returns a (possibly empty) array
    of human-readable violation strings. The rule is asymmetric:
      - customer_deployment = false ⇒ the config's subscription must NOT be a customer subscription (a
        non-customer template may not deploy into a customer subscription);
      - customer_deployment = true  ⇒ if the config's subscription IS a customer subscription, that customer
        must be ENABLED by the have_customers variant (Test-HaveCustomer). A true template may still deploy
        into non-customer subscriptions.
    Empty result means the config conforms.
.PARAMETER Subscription
    The subscription-folder name (a key in azure.yml's subscriptions).
.PARAMETER CustomerDeployment
    The template's effective customer_deployment bit.
.PARAMETER AzureConfig
    The loaded azure config (Get-Config -Config azure) — used to read the subscription's customer field.
.PARAMETER Location
    A human-readable label for the config (e.g. 'configuration/acme_lower/alpha.yml') used in messages.
#>
function Get-BicepCustomerClassViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)] [string] $Subscription,
        [Parameter(Mandatory)] [bool] $CustomerDeployment,
        [Parameter(Mandatory)] $AzureConfig,
        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()

    $token = ''
    if ($AzureConfig.subscriptions.Contains($Subscription)) {
        $token = Get-AzureSubscriptionCustomer $AzureConfig.subscriptions[$Subscription]
    }
    $isCustomerSubscription = -not [string]::IsNullOrEmpty($token)

    if (-not $CustomerDeployment) {
        if ($isCustomerSubscription) {
            $violations += "$Location deploys into customer subscription '$Subscription', but the template is not a customer_deployment — set 'customer_deployment: true' in options.yml (and enable customers via have_customers in variants.yml)"
        }
        return $violations
    }

    if ($isCustomerSubscription) {
        # The customer this config deploys for must be enabled by the have_customers variant. The token may
        # be a key or a shortcode; Test-HaveCustomer handles 'all' and key lists without reading customer.yml,
        # and only a shortcode-vs-list mismatch needs a resolve to the canonical key.
        if (-not (Test-HaveCustomer -Name $token)) {
            $customerKey = (Get-AzureCustomer $token).key
            if (-not (Test-HaveCustomer -Name $customerKey)) {
                $violations += "$Location deploys for customer '$customerKey', which is not enabled by have_customers in variants.yml"
            }
        }
    }

    $violations
}
