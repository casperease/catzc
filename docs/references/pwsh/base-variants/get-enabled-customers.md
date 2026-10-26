# pwsh/Base.Variants/Get-EnabledCustomers.ps1

The single interpreter of the tri-state `have_customers` variant: it turns what the repo declares into no customers, every customer, or a
list of names, and the customer guards read only its answer.

## help

### synopsis

Returns the repo's enabled-customer set from the `have_customers` variant.

### description

Normalizes the tri-state `have_customers` variant (configs/variants.yml) to one of:

```text
@()      — no customers enabled (variant is false, or an empty list): only non-customer templates
'all'    — every customer defined in customer.yml is enabled (variant is true or the string 'all')
@(names) — only these named customers are enabled (variant is a list)
```

This is the single interpreter of the tri-state; Test-/Assert-HaveCustomers read it. It reports which customers are enabled `*by` `policy*`
— whether a listed name is a defined customer is a customer.yml (Azure-layer) concern, cross-checked by an integrity test, not here.

### example 1

```powershell
Get-EnabledCustomers   # -> @()  (default: customers disabled)
```

## Reading a non-bool value

A value that is not a bool is either `'all'` or a list of names. A one-element list comes back from `Get-Variant` as a scalar, so the value
is first made an array of non-empty strings; then a lone `'all'` means every customer, and anything else is the list of enabled names.
