<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns the customer-class violations for a single resolved config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two never
    drift. Parallels Get-BicepConfigClassViolations. See [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
.DESCRIPTION
    The rule is asymmetric: a false template allows root configs only, a true one allows customer folders too.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md#comment1)
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
