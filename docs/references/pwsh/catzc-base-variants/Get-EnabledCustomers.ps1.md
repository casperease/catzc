# pwsh/Base.Variants/Get-EnabledCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$names = @($value | Where-Object { -not [string]::IsNullOrEmpty("$_") } |...`, written with `#`.

```text
Anything non-bool is 'all' or a name list. A single-element list unrolls to a scalar on return from
Get-Variant, so normalize to an array of non-empty strings before deciding — a lone 'all' is the
every-customer sentinel; everything else is the enabled-name list.
```
