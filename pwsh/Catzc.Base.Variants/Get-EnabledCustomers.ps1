<#
---
catzc:
  immutable:
    with_body_sha: "981e565c0b67"
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-EnabledCustomers.Tests.ps1
    docs: "[Get-EnabledCustomers.ps1.md](../../docs/references/pwsh/catzc-base-variants/Get-EnabledCustomers.ps1.md)"
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
