---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9ff2ea485afa"
    adrs:
      - ADR-AZ-NAMING#8
---

# automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1

<!-- cspell:ignore deweuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$envEntry = $azure.environments[$Environment]`, written with `#`.

```text
Naming needs only the environment's IDENTITY (shortcode/region_code), never a subscription — so it
reads azure.yml directly and is independent of subscription group/customer. The subscription group
is a resolution axis only and is never a name component
([ADR-AZ-NAMING#8](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming8)).
```

## comment:2

Above `$nameArgs = @{`, written with `#`.

```text
The namer picks the env form by pattern (name for generous, shortcode for restricted); env and
slot are separate segments. We pass both forms + the slot and let it choose.
```

## comment:3

Above `$resolvedCustomer = Get-AzureCustomer $Customer`, written with `#`.

```text
Resolve the customer (given by key OR 2-char shortcode) to its canonical key + shortcode from
customer.yml: the readable key renders in generous patterns, the 2-char shortcode in the
restricted ones (the namer picks per type). Get-AzureCustomer throws on an unknown token.
```
