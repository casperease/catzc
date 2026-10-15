---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
    kind: comment-page
    body_sha: "509457381e3d"
    adrs:
      - ADR-AZ-NAMING#8
---

# automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1

<!-- cspell:ignore deweuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The templating-layer name generator. It resolves the name components from the template and
environment, then assembles the name for the requested resource type via Get-AzureResourceName:
  - env         — the environment NAME (generous types) and its 2-char shortcode (restricted)
  - slot        — the optional special-slot discriminator (`-Slot`)
  - region_code — the environment's azure.yml region_code
  - org         — azure.yml top-level org
  - short_name  — the template's options.yml short_name
  - order       — the active naming order (Get-AdoNaming; the ado_naming repo-wide variant)

The caller supplies only what is genuinely per-call: the resource Type and optional Customer /
Role. Two intended uses for the same generator:
  validation — compare a name configured in a template's ParametersFile against the generated
               one to catch drift.
  generation — produce the name to inject into the built parameter files (the PrePost seam).
```

## comment:2

Section `.PARAMETER Customer` of the comment-based help.

```text
Optional customer, named by its key OR its 2-char shortcode (customer.yml). Its readable key renders in
generous names and its 2-char shortcode in restricted ones — both resolved here (Get-AzureCustomer) and
passed to the namer.
```

## comment:3

Above `$envEntry = $azure.environments[$Environment]`.

```text
Naming needs only the environment's IDENTITY (shortcode/region_code), never a subscription — so it
reads azure.yml directly and is independent of subscription group/customer. The subscription group
is a resolution axis only and is never a name component
([ADR-AZ-NAMING#8](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming8)).
```

## comment:4

Above `$nameArgs = @{`.

```text
The namer picks the env form by pattern (name for generous, shortcode for restricted); env and
slot are separate segments. We pass both forms + the slot and let it choose.
```

## comment:5

Above `$resolvedCustomer = Get-AzureCustomer $Customer`.

```text
Resolve the customer (given by key OR 2-char shortcode) to its canonical key + shortcode from
customer.yml: the readable key renders in generous patterns, the 2-char shortcode in the
restricted ones (the namer picks per type). Get-AzureCustomer throws on an unknown token.
```

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
