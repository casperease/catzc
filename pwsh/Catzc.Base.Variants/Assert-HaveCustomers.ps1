<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Assert-HaveCustomers.ps1
    name: assert-have-customers
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Assert-HaveCustomers.Tests.ps1
    docs: "[Assert-HaveCustomers.ps1.md](docs/references/pwsh/catzc-base-variants/Assert-HaveCustomers.ps1.md)"
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
