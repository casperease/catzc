---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENGINE-AUTONAMESNOENGINE
      - ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN
---

# Auto is the engine value that names no engine and leaves each layers choice open

This article is one rule:
[ADR-AUTO-ENGINE-AUTONAMESNOENGINE](../../drs/automation/execution-engines.md#rule-adr-auto-engine-autonamesnoengine) and
[ADR-AUTO-LAYERS-AUTOLEAVESCHOICEOPEN](../../drs/automation/layers.md#rule-adr-auto-layers-autoleaveschoiceopen) merged into one. It holds
nothing beyond what those two rules say.

`auto` is the engine value that names no particular engine: a setting or argument that says `auto` takes whatever engine its sensible
default resolves to, and names pwsh, bash or zsh only when it needs that one. `auto` is not a fourth engine and never appears in the model's
`Names`. In every layer it leaves the choice open, for the languages meaning the languages of the loaded modules, and resolves in the one
resolution order of a setting.
