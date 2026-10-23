---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN
      - ADR-AUTO-IMPORTER-DECIDESMIX
---

# The importer decides the mix and auto leaves each choice open (ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN + ADR-AUTO-IMPORTER-DECIDESMIX)

This article is one rule: [ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN](../../drs/automation/layers.md#rule-adr-auto-layers-autoleaveschoiceopen)
and [ADR-AUTO-IMPORTER-DECIDESMIX](../../drs/automation/importer.md#rule-adr-auto-importer-decidesmix) merged into one. It holds nothing
beyond what those two rules say.

The importer decides the mix a session loads: which languages, which engines and which modules. Each input resolves in the one order of a
setting: the caller's explicit value, else the importer's configuration, else the default. `auto` is the value that leaves a layer's choice
open, naming no engine and meaning the languages of the loaded modules.
