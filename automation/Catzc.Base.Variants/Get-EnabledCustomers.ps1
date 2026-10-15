<#
.SYNOPSIS
    Returns the repo's enabled-customer set from the `have_customers` variant.
.DESCRIPTION
    Normalizes the tri-state `have_customers` variant (configs/variants.yml) to one of: @ — no customers enabled...
    [comment:1](/docs/references/automation/catzc-base-variants/Get-EnabledCustomers.ps1.md#comment1)
.EXAMPLE
    Get-EnabledCustomers   # -> @()  (default: customers disabled)
#>
function Get-EnabledCustomers {
    [CmdletBinding()]
    param()

    $value = Get-Variant -Name have_customers -Default $false

    if ($value -is [bool]) {
        if ($value) {
            return 'all'
        }
        return @()
    }

    # Anything non-bool is 'all' or a name list.
    # [comment:2](/docs/references/automation/catzc-base-variants/Get-EnabledCustomers.ps1.md#comment2)
    $names = @($value | Where-Object { -not [string]::IsNullOrEmpty("$_") } | ForEach-Object { "$_" })
    if ($names.Count -eq 0) {
        return @()
    }
    if ($names.Count -eq 1 -and $names[0] -ceq 'all') {
        return 'all'
    }
    , @($names)
}
