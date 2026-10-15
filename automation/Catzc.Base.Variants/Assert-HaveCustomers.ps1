<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Assert-HaveCustomers.ps1
    kind: function
    module: Catzc.Base.Variants
    visibility: public
---
#>

<#
.SYNOPSIS
    Asserts the repo has customer deployments enabled — for all customers, or for specific names — else throws.
.DESCRIPTION
    No -Name requires any customer enabled; with -Name every name must be, and the error lists the missing ones.
    [comment:1](/docs/references/automation/catzc-base-variants/Assert-HaveCustomers.ps1.md#comment1)
.PARAMETER Name
    Zero or more customer names to require. Omit to require the repo-wide capability.
.EXAMPLE
    Assert-HaveCustomers
.EXAMPLE
    Assert-HaveCustomers -Name acme
#>
function Assert-HaveCustomers {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name
    )

    if (-not $PSBoundParameters.ContainsKey('Name')) {
        Assert-True (Test-HaveCustomers) -ErrorText 'Customer deployments are disabled — set have_customers in variants.yml (all, or a list of customer names).'
        return
    }

    $notEnabled = @($Name | Where-Object { -not (Test-HaveCustomers -Name $_) })
    Assert-True ($notEnabled.Count -eq 0) -ErrorText "Customer(s) not enabled for this repo: $($notEnabled -join ', ') — set have_customers in variants.yml (all, or include them in the list)."
}
