---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
    kind: comment-page
    body_sha: b4361d548d63
    adrs:
      - ADR-AZ-NAMING#8
---

# automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1

<!-- cspell:ignore deweuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$envEntry = $azure.environments[$Environment]`.

```text
Naming needs only the environment's IDENTITY (shortcode/region_code), never a subscription — so it
reads azure.yml directly and is independent of subscription group/customer. The subscription group
is a resolution axis only and is never a name component
([ADR-AZ-NAMING#8](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming8)).
```

## comment:7

Above `$nameArgs = @{`.

```text
The namer picks the env form by pattern (name for generous, shortcode for restricted); env and
slot are separate segments. We pass both forms + the slot and let it choose.
```

## comment:8

Above `$resolvedCustomer = Get-AzureCustomer $Customer`.

```text
Resolve the customer (given by key OR 2-char shortcode) to its canonical key + shortcode from
customer.yml: the readable key renders in generous patterns, the 2-char shortcode in the
restricted ones (the namer picks per type). Get-AzureCustomer throws on an unknown token.
```
