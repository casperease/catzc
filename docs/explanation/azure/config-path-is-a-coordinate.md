---
catzc:
  immutable:
    with_body_sha: "2356399464e7"
    repo_status: clean
    path: docs/explanation/azure/config-path-is-a-coordinate.md
    folder: docs/explanation/azure
    name: config-path-is-a-coordinate
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AZ-CUSTOMER#6
      - ADR-AZ-DATAMOD#{1-3}
    links:
      - docs/.assets/explanation/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.md
      - docs/.assets/explanation/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.png
      - docs/adr/azure/azure-customer-model.md
      - docs/adr/azure/azure-data-model.md
      - docs/explanation/azure/a-bad-coordinate-stops-discovery.md
      - docs/explanation/azure/coordinate-resolved-file-by-file-at-discovery.md
      - docs/explanation/azure/coordinate-rules-and-their-gates.md
      - docs/explanation/azure/index.md
      - docs/explanation/azure/two-layers-join-through-one-resolver.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# A config file's path is a coordinate that resolves to one subscription and one resource group

```text
A config file's path is a coordinate that resolves to one subscription and one resource group.

1  root config               a config at the configuration root: a deployment of the shared platform
2  customer config           a config under configuration/<customer>/: a deployment of that customer
3  exactly one subscription  the check that the coordinate is served by exactly one subscription
4  subscription              the one subscription the coordinate resolves to, never spelled into the path
5  resource group            the one resource group the config deploys, its name derived from the coordinate

Supports ADR-AZ-DATAMOD#1, #2 and #3, and ADR-AZ-CUSTOMER#6 (meta lens).
```

A Bicep template in cats keeps one config file per deployment under its `configuration/` folder, and where that file sits is its whole
address. The file's folder says whose deployment it is, and its name says which environment and which slot. Nothing in the file, and nothing
in any pipeline, names the subscription: cats resolves it from the path, and it insists that exactly one subscription fits. Because the
resolution is one-to-one all the way through, listing the `configuration/` tree is the inventory of a template's resource groups.

![A config file's path is a coordinate that resolves to one subscription and one resource group](../../.assets/explanation/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.md).

## Walkthrough

1. **Root config.** A file at the configuration root, `configuration/<env>[-<slot>].yml`, is a deployment of the shared platform. Its
   coordinate has no customer, so only the non-customer subscriptions can serve it.
2. **Customer config.** A file under a subfolder, `configuration/<customer>/<env>[-<slot>].yml`, is that customer's deployment. The
   subfolder is always a customer key from the customer catalogue, so a subfolder that names no customer is a discovery error.
3. **Exactly one subscription.** The coordinate (customer?, env) is matched against the subscriptions of `azure.yml`: those serving the
   environment, filtered to the non-customer ones for a root config or to the customer's own for a customer config. Exactly one must remain.
   Zero or several stop discovery, which is how the shared platform stays one platform and a customer's environments stay disjoint. The slot
   plays no part in this choice.
4. **Subscription.** The one match is the subscription the config deploys into. It is a resolved value, never an argument and never a path
   segment, so no subscription name appears anywhere in the templating layer.
5. **Resource group.** Each config is one slot and one resource group. The group's name is derived from the coordinate by the namer, never
   typed into a config, so the file, the subscription and the group stay one-to-one.

## Why it holds

- A config at the configuration root is the shared platform's and a config under a customer subfolder is that customer's; the subscription
  is always resolved from that coordinate and never spelled into a path (ADR-AZ-DATAMOD#1).
- One config file is one (customer?, env, slot), one subscription and one Azure resource group, at
  `configuration/[<customer>/]<env>[-<slot>].yml`, so listing the tree is the resource-group inventory (ADR-AZ-DATAMOD#2).
- A configuration subfolder is always a customer key, and every coordinate must resolve to exactly one subscription: a root config's
  environment to one non-customer subscription, a customer config's environment to one of that customer's, asserted per file at discovery
  and by integrity tests (ADR-AZ-DATAMOD#3).
- The customer key is the subfolder name, one spelling on disk; the shortcode never names a folder (ADR-AZ-CUSTOMER#6).

## See also

- [Templating data model](../../adr/azure/azure-data-model.md) — the decision this article explains, with the
  [customer model](../../adr/azure/azure-customer-model.md) it pairs with.
- The other lenses on the same coordinate: [architecture](two-layers-join-through-one-resolver.md),
  [implementation](coordinate-resolved-file-by-file-at-discovery.md), [operations](a-bad-coordinate-stops-discovery.md) and
  [governance](coordinate-rules-and-their-gates.md).
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
