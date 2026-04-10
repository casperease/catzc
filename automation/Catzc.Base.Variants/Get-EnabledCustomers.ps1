<#
.SYNOPSIS
    Returns the repo's enabled-customer set from the `have_customers` variant.
.DESCRIPTION
    Normalizes the tri-state `have_customers` variant (configs/variants.yml) to one of:
      @()      — no customers enabled (variant is false, or an empty list): only non-customer templates
      'all'    — every customer defined in customer.yml is enabled (variant is true or the string 'all')
      @(names) — only these named customers are enabled (variant is a list)
    This is the single interpreter of the tri-state; Test-/Assert-HaveCustomers read it. It reports which
    customers are enabled *by policy* — whether a listed name is a defined customer is a customer.yml
    (Azure-layer) concern, cross-checked by an integrity test, not here.
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

    # Anything non-bool is 'all' or a name list. A single-element list unrolls to a scalar on return from
    # Get-Variant, so normalize to an array of non-empty strings before deciding — a lone 'all' is the
    # every-customer sentinel; everything else is the enabled-name list.
    $names = @($value | Where-Object { -not [string]::IsNullOrEmpty("$_") } | ForEach-Object { "$_" })
    if ($names.Count -eq 0) {
        return @()
    }
    if ($names.Count -eq 1 -and $names[0] -ceq 'all') {
        return 'all'
    }
    , @($names)
}
