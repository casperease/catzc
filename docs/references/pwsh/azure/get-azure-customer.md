# pwsh/Azure/Get-AzureCustomer.ps1

The resolver from a customer reference to the canonical customer record of `configs/customer.yml`. A reference may be a key or a shortcode,
and callers need one form, so this is the single place that turns either into the record.

## help

### synopsis

Resolves a customer reference (its key OR its shortcode) to the canonical customer record.

### description

A customer is named two ways — its readable key (apex) or its 2-char shortcode (ap). A subscription's `customer` field in azure.yml may use
either; this resolves both to the same record so downstream code always works with the canonical key. Reads customer.yml (Get-Config -Config
customer). The key/shortcode name-spaces are kept distinct by the CustomerConfig type, so the match is unambiguous: keys first, then
shortcodes. Throws when the token is neither.

### parameter `Name`

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
