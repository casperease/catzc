# pwsh/Azure.Templates/types/BicepTemplate.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

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

Above `public bool customer_deployment { get; }`, written with `//`.

```text
Whether this is a customer template (its configs deploy into customer subscriptions). Defaults to the
have_customers repo variant; see [ADR-AZ-CUSTOMER](/docs/drs/azure/azure-customer-model.md). Always present (a bool).
```

## comment:3

Above `public BicepTemplate(IDictionary d)`, written with `//`.

```text
Constructed from the parsed-and-overlaid configuration dictionary; the constructor validates required
keys (a malformed template cannot produce an instance).
```
