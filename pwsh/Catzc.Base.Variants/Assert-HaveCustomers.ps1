<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Assert-HaveCustomers.ps1.md"
  warning: "Generated Header"
---
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
