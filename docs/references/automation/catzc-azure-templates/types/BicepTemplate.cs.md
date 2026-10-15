---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepTemplate.cs.md
    kind: reference
    body_sha: fae676a217fa
    adrs: []
---

# automation/Catzc.Azure.Templates/types/BicepTemplate.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A discovered deployable template — one folder of Bicep under the templates tree, plus the deployment
axes (environments × subscriptions × customers) it fans out across, materialised as `slots`. The
definitional record a deploy is planned from; mirrors a template's config keys (snake_case), overlaid
with options.yml, and is constructed from that merged dictionary.

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties (Contains/indexer/Keys/ToHashtable) and its constructor uses the base's
Req/OptStr/StrArr extraction helpers.
```

## comment:2

Above `public bool customer_deployment { get; }`.

```text
Whether this is a customer template (its configs deploy into customer subscriptions). Defaults to the
have_customers repo variant; see [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md). Always present (a bool).
```

## comment:3

Above `public BicepTemplate(IDictionary d)`.

```text
Constructed from the parsed-and-overlaid configuration dictionary; the constructor validates required
keys (a malformed template cannot produce an instance).
```
