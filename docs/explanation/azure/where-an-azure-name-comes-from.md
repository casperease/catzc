# Where an Azure name comes from

```text
Where an Azure name comes from.

1  variants.yml             the naming variant: the component order for every name
2  options.yml              an optional short_name: the setting to shorten or pin
3  Deploy-Bicep             deploys to the resource group the slot declares
4  Get-BicepResourceName    prints the canonical name for a coordinate without deploying anything
5  Get-AzureResourceName    the namer; the one renderer, the form every declared name is matched against
6  dev-001-weu-zct-sidx-rg  the name that passes: printed, or the one a slot declares
7  throw                    an error to act on: fix a setting or a declared name and rerun

Supports ADR-AZ-NAMING-DETERMINISTICNAMES, ADR-AZ-NAMING-ORDERISVARIANT, ADR-AZ-NAMING-LOWERCASECOMPONENTS,
ADR-AZ-NAMING-NEVERTRUNCATE and ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT (operations lens).
```

An Azure resource name in cats is written in full in the slot config that deploys it, and the name gate matches it against the canonical
form the naming standard renders from settings the repository already holds. A person runs a deploy or asks for the canonical name. A name
that does not match, or an over-long one, stops with an error that says what is wrong, and the fix is a setting or the declared name, never
a truncated name.

```yml drawio
description:
  An operator changes the naming variant or a template's short name and runs a deploy or asks for a name; the name matches the canonical
  form or the run stops with an error to act on.
about:
  rules:
    - ADR-AZ-NAMING-DETERMINISTICNAMES
    - ADR-AZ-NAMING-ORDERISVARIANT
    - ADR-AZ-NAMING-LOWERCASECOMPONENTS
    - ADR-AZ-NAMING-NEVERTRUNCATE
    - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
  lens: operations
content:
  title: Where an Azure name comes from
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-change, label: YOU CHANGE }
    - { id: band-run, label: YOU RUN }
    - { id: band-get, label: YOU GET }
  glyphs:
    - { id: g-variants, kind: file, label: variants.yml, in: band-change }
    - { id: g-options, kind: file, label: options.yml, in: band-change }
    - { id: g-deploy, kind: code, label: Deploy-Bicep, in: band-run }
    - { id: g-resource-name, kind: code, label: Get-BicepResourceName, in: band-run }
    - { id: g-namer, kind: code, label: Get-AzureResourceName, in: band-get }
    - { id: r-name, kind: result, label: dev-001-weu-zct-sidx-rg, in: band-get }
    - { id: f-throw, kind: failure, label: throw, in: band-get }
  edges:
    - { from: g-resource-name, to: g-variants, kind: flow, label: reads }
    - { from: g-resource-name, to: g-options, kind: flow, label: reads }
    - { from: g-deploy, to: g-resource-name, kind: flow, label: calls }
    - { from: g-resource-name, to: g-namer, kind: flow, label: calls }
    - { from: g-namer, to: r-name, kind: flow, label: "" }
    - { from: g-namer, to: f-throw, kind: fail, label: "" }
  markers:
    - { at: g-variants, number: 1 }
    - { at: g-options, number: 2 }
    - { at: g-deploy, number: 3 }
    - { at: g-resource-name, number: 4 }
    - { at: g-namer, number: 5 }
    - { at: r-name, number: 6 }
    - { at: f-throw, number: 7 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-change: { x: 20, y: 84, w: 1260, h: 110 }
  band-run: { x: 20, y: 214, w: 1260, h: 100 }
  band-get: { x: 20, y: 334, w: 1260, h: 200 }
  g-variants: { x: 700, y: 122, w: 240, h: 52 }
  g-options: { x: 1000, y: 122, w: 240, h: 52 }
  g-deploy: { x: 140, y: 246, w: 280, h: 44 }
  g-resource-name: { x: 700, y: 246, w: 540, h: 44 }
  g-namer: { x: 820, y: 374, w: 300, h: 44 }
  r-name: { x: 140, y: 374, w: 420, h: 44 }
  f-throw: { x: 820, y: 464, w: 300, h: 44 }
```

![Where an Azure name comes from](.assets/where-an-azure-name-comes-from.drawio.png)

## Walkthrough

1. **variants.yml.** Its `naming` variant picks the component order for every name, a preset (`standard` by default, or `classic`) or an
   explicit list of segments, and a consumer can overlay it from `.catzc/`. Changing it changes the canonical form, so every declared name
   fails the name gate until it is re-spelled; it is deliberately not a flip-the-switch option.
2. **options.yml.** A template's optional `options.yml` can set an explicit `short_name`. That is the setting to shorten when a name runs
   over its limit, and the way to pin a template's Azure identity against a folder rename.
3. **Deploy-Bicep.** `Deploy-Bicep -Environment -Template [-Slot]` deploys to the resource group the slot declares in its `ResourceGroup:`
   key. The customer comes from the az session's subscription, not from an argument, and in a pipeline the command also needs
   `-SubscriptionIdAssertIs`.
4. **Get-BicepResourceName.** `Get-BicepResourceName <template> <env> <type> [-Slot] [-Customer] [-Role]` prints the canonical name for a
   coordinate without deploying anything, the spelling to write into a slot. It tab-completes templates, environments, types, slots and
   customers.
5. **Get-AzureResourceName.** The namer applies the naming standard and is the one renderer the name gate matches candidates through. The
   same inputs always give the same name.
6. **dev-001-weu-zct-sidx-rg.** The name that passes: printed, or declared in the slot. It is what
   `Get-BicepResourceName -Template sample-indexed -Environment dev -Slot 001 -Type rg` prints.
7. **Throw.** An error to act on, such as `Invalid Org 'X' — must be 2-3 alphanumeric, leading letter, lowercase.`,
   `Unknown customer 'X' — not a customer key or shortcode in customer.yml …`, a declared name with a per-part diagnosis from
   `Test-BicepResourceNames`, or `Resource name '…' (30 chars) exceeds the 'kv' limit of 24 — shorten short_name / slot / customer / role.`
   The fix is to correct the declared name, or to shorten and rerun: set a shorter `short_name` in `options.yml`, or pass a shorter `-Slot`
   or `-Role`.

## Why it holds

- Every name is written in full in its slot and matched against the one canonical component set, so a drifted name fails before a deploy
  (ADR-AZ-NAMING-DETERMINISTICNAMES).
- The component order is the `naming` repo variant, and changing it changes the canonical form every declared name is matched against
  (ADR-AZ-NAMING-ORDERISVARIANT).
- Components are lowercase and validated case-sensitively, so a malformed value stops the run (ADR-AZ-NAMING-LOWERCASECOMPONENTS).
- A name is never truncated to fit; the namer throws at deploy time instead (ADR-AZ-NAMING-NEVERTRUNCATE).
- The subscription picks the deploy target and the customer, never a name segment (ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT).

An external name collision on a globally unique type also fails the deploy. That is Azure's behaviour, which the record states: the fix is
the same, adjust the slot or the `short_name`, and there is no automatic hash.

## See also

- [Azure resource naming standard](../../drs/azure/azure-naming-standard.md) — the decision this article explains.
- The other lenses on the same naming standard: [meta](what-an-azure-name-is-made-from.md),
  [architecture](which-code-builds-azure-names.md), [implementation](how-an-azure-resource-gets-its-name.md) and
  [governance](how-the-azure-naming-rules-are-enforced.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
