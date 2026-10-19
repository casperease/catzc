# An Azure name is a pure function of its components, and it is never truncated

<!-- cspell:ignore weufindiscxaphotst weudiscvm -->

```text
An Azure name is computed from fixed components; it fits its limit or the deploy stops.

1  fixed components  one canonical set in a fixed order, environment first
2  type pattern      picks the environment and customer form, and the length limit
3  <= limit?         the rendered name is checked against that limit
4  throw             a name that is too long stops the deploy, never truncated
5  the same name     a name that fits; the same inputs give it every time

Supports ADR-AZ-NAMING-DETERMINISTICNAMES, ADR-AZ-NAMING-ENVIRONMENTFIRST, ADR-AZ-NAMING-NEVERTRUNCATE and ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT (meta lens).
```

An Azure resource name in cats is not chosen; it is computed. Fixed components go in, the resource type's pattern decides their form and the
length budget, and the name either fits that budget or the deploy stops. The same inputs give the same name every time, so a name can be
predicted, compared and reproduced without looking anything up in Azure.

![An Azure name is a pure function of its components, and it is never truncated](.assets/names-are-pure-and-never-truncated/diagram.drawio.png)

## Walkthrough

1. **Fixed components.** A name is built from one canonical set of components in a fixed order, with the environment first, so names sort by
   environment. An optional component that is empty is dropped.
2. **Type pattern.** The resource type's pattern picks the form of the environment and customer segments, either the readable name or the
   2-char shortcode, and sets the length limit.
3. **≤ limit?** The rendered name is checked against that limit.
4. **Throw.** A name that is too long throws and stops the deploy. It is never truncated and never hashed.
5. **The same name.** A name that fits is returned, and the same inputs return the same name every time. The naming standard's own examples
   render exactly as written: `prod-weu-fin-disc-rg` (20 characters), `pr001weufindiscxaphotst` (23) and `pr001weudiscvm` (14).

## Why it holds

- No random suffix, hash or truncation ever enters a name: every name is assembled deterministically from one canonical component set
  (ADR-AZ-NAMING-DETERMINISTICNAMES), and a name over its limit throws instead of being cut (ADR-AZ-NAMING-NEVERTRUNCATE).
- The environment is the first segment, and the restricted patterns use its 2-char shortcode, so a readable name never costs a tight name a
  byte (ADR-AZ-NAMING-ENVIRONMENTFIRST).
- The subscription selects where a deploy goes but never enters the name (ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT).

## See also

- [Azure resource naming standard](../../adr/azure/azure-naming-standard.md) — the decision this article explains.
- The other lenses on the same naming standard: [architecture](one-namer-assembles-every-name.md),
  [implementation](lookup-form-check-render-in-order.md), [operations](names-are-derived-never-typed.md) and
  [governance](how-each-naming-rule-is-held.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
