<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Test-HaveCustomers.ps1
    name: test-have-customers
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md
      test: automation/Catzc.Base.Variants/tests/Test-HaveCustomers.Tests.ps1
  config:
    synopsis: Tests whether the repo has customer deployments enabled — for all customers, or for specific names.
    description: |-
      A predicate over the `have_customers` repo-wide variant (see Get-EnabledCustomers). With no -Name it
      answers "is the repo customer-enabled at all" (the variant is 'all' or a non-empty list). With -Name it
      answers "are all the named customers enabled" (the variant is 'all', or each name is in the list). A
      guard callable anywhere above the Config layer; use Assert-HaveCustomers to fail instead of branch.

      Enabled here means enabled by repo policy (the variant). Whether a name is a *defined* customer is a
      customer.yml (Azure-layer) concern.
    parameters:
      Name: Zero or more customer names to test for enablement. Omit to test the repo-wide capability.
    examples:
      - 'if (Test-HaveCustomers) { ... }              # any customers enabled?'
      - 'Test-HaveCustomers -Name acme, globex        # are both enabled?'
---
#>

function Test-HaveCustomers {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name
    )

    $enabled = Get-EnabledCustomers
    $isAll = ($enabled -is [string]) -and ($enabled -ceq 'all')
    # assigned in the branch, not from an if-expression, which would unroll a 0/1-item array to $null/a scalar
    $enabledList = @()
    if (-not $isAll) {
        $enabledList = @($enabled)
    }
    $any = $isAll -or ($enabledList.Count -gt 0)

    if (-not $PSBoundParameters.ContainsKey('Name')) {
        return [bool] $any
    }
    if (-not $any) {
        return $false
    }
    if ($isAll) {
        return $true
    }
    foreach ($customer in $Name) {
        if ("$customer" -notin $enabledList) {
            return $false
        }
    }
    $true
}
