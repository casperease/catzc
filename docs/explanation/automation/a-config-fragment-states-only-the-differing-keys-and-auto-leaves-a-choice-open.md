---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-OVERLAY-CONFIGFRAGMENT
      - ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN
---

# A config fragment states only the differing keys and auto leaves a choice open

This article is one rule: [ADR-AUTO-OVERLAY-CONFIGFRAGMENT](../../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-configfragment)
and [ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN](../../drs/automation/layers.md#rule-adr-auto-layers-autoleaveschoiceopen) merged into one. It
holds nothing beyond what those two rules say.

A config fragment states only the keys that differ and is merged onto the bundled config before the config's own type validates the result:
a map merges key by key, a scalar or a list replaces the bundled value, and an explicit `null` removes the key so the type's declared
default applies. `auto` leaves a layer's choice open and resolves in the one resolution order of a setting.
