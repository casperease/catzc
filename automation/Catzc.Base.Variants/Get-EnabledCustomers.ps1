# catzc:
#   path: automation/Catzc.Base.Variants/Get-EnabledCustomers.ps1
#   module: Catzc.Base.Variants
#   visibility: public

<#
.SYNOPSIS
    Returns the repo's enabled-customer set from the `have_customers` variant.
.DESCRIPTION
    The one interpreter of the tri-state: false or empty gives @(), true or 'all' gives 'all', a list gives names.
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

    # Get-Variant unrolls a one-item list to a scalar, so normalize to an array before spotting the 'all' sentinel.
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
