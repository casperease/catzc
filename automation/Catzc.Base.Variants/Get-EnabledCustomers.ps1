<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Get-EnabledCustomers.ps1
    name: get-enabled-customers
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-variants/Get-EnabledCustomers.ps1.md
    test: automation/Catzc.Base.Variants/tests/Get-EnabledCustomers.Tests.ps1
---
#>

function Get-EnabledCustomers {
    [CmdletBinding()]
    param()

    $value = Get-Variant -Name have_customers

    if ($value -is [bool]) {
        if ($value) {
            return 'all'
        }
        return @()
    }

    $names = @($value | Where-Object { -not [string]::IsNullOrEmpty("$_") } | ForEach-Object { "$_" })
    if ($names.Count -eq 0) {
        return @()
    }
    if ($names.Count -eq 1 -and $names[0] -ceq 'all') {
        return 'all'
    }
    , @($names)
}
