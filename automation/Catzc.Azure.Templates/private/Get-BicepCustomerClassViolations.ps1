<#
.SYNOPSIS
    Returns the customer-class violations for a single resolved config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two never
    drift. Parallels Get-BicepConfigClassViolations. See docs/adr/azure/customer-model.md.
.DESCRIPTION
    Checks one config against the template's `customer_deployment` bit and returns a (possibly empty) array
    of human-readable violation strings. The config's customer is its configuration subfolder ('' for a
    configuration-root config). The rule is asymmetric:
      - customer_deployment = false ⇒ the config must NOT live under a customer subfolder (a non-customer
        template ships root configs only);
      - customer_deployment = true  ⇒ a customer subfolder is allowed, but its customer must be ENABLED by
        the have_customers variant (Test-HaveCustomer). A true template may still ship root configs.
    Empty result means the config conforms.
.PARAMETER Customer
    The configuration subfolder name (a customer key), or '' for a configuration-root config.
.PARAMETER CustomerDeployment
    The template's effective customer_deployment bit.
.PARAMETER Location
    A human-readable label for the config (e.g. 'configuration/acme/alpha.yml') used in messages.
#>
function Get-BicepCustomerClassViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyString()]
        [string] $Customer,

        [Parameter(Mandatory)] [bool] $CustomerDeployment,
        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()

    if ([string]::IsNullOrEmpty($Customer)) {
        return $violations
    }

    if (-not $CustomerDeployment) {
        $violations += "$Location deploys for customer '$Customer', but the template is not a customer_deployment — set 'customer_deployment: true' in options.yml (and enable customers via have_customers in variants.yml)"
        return $violations
    }

    if (-not (Test-HaveCustomer -Name $Customer)) {
        $violations += "$Location deploys for customer '$Customer', which is not enabled by have_customers in variants.yml"
    }

    $violations
}
