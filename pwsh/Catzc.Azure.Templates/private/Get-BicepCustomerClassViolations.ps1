<#
---
catzc:
  immutable:
    with_body_sha: "3c7a04dabafd"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepCustomerClassViolations.Tests.ps1
    docs: "[Get-BicepCustomerClassViolations.ps1.md](../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md)"
    cites:
      - ADR-AZ-CUSTOMER
---
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
