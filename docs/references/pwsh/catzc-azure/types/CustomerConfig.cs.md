# pwsh/Catzc.Azure/types/CustomerConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The customer catalogue (configs/customer.yml, [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)) — the
customers this repo can deploy for; WHICH of them are enabled is the have_customers variant, not this file.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.CustomerConfig), so
Get-Config -Config customer returns this typed record. Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - the top-level key 'customers' is required (an empty map is allowed) and is the only key;
  - every entry is a well-formed AzureCustomer (key and shortcode formats);
  - shortcodes are unique;
  - no key equals any shortcode — a subscription's `customer` field may name a customer by its key OR its
    shortcode, so a collision would make that reference ambiguous
    ([ADR-AZ-CUSTOMER-TWOBINDINGS](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer-twobindings)).
Self-contained — it does NOT read azure.yml (a subscription references a customer here, so azure.yml depends
on customer.yml, never the reverse; [ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)).
```

## comment:2

Above `public IReadOnlyDictionary<string, AzureCustomer> customers { get; }`, written with `//`.

```text
The catalogue, keyed by customer key in file order (a Dictionary enumerates in insertion order when nothing
is removed, and this one is never mutated after construction).
```
