# automation/Catzc.Azure/Get-AzureCustomer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a customer reference (its key OR its shortcode) to the canonical customer record.

### description

A customer is named two ways — its readable key (apex) or its 2-char shortcode (ap). A subscription's
`customer` field in azure.yml may use either; this resolves both to the same record so downstream code
always works with the canonical key. Reads customer.yml (Get-Config -Config customer). The key/shortcode
name-spaces are kept distinct by the CustomerConfig type, so the match is unambiguous: keys first, then
shortcodes. Throws when the token is neither.

### parameter Name

A customer key or shortcode.

### outputs

An ordered dictionary: @{ key; shortcode; details }.

### example 1

```powershell
(Get-AzureCustomer apex).key   # -> apex
```

### example 2

```powershell
(Get-AzureCustomer ap).key     # -> apex  (resolved by shortcode)
```
