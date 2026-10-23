---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENVVAR-SETONLYFORTOOLS
      - ADR-PWSH-ENV-NOHANDOFF
---

# An environment variable is set only for an external tool never handed between functions

This article is one rule:
[ADR-AUTO-ENVVAR-SETONLYFORTOOLS](../../drs/automation/environment-variables.md#rule-adr-auto-envvar-setonlyfortools) and
[ADR-PWSH-ENV-NOHANDOFF](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-nohandoff) merged into one. It holds
nothing beyond what those two rules say.

Set an environment variable only to meet an external tool's contract. When the consumer is our own code, the value travels as a parameter or
in module state. So no function of ours assigns `$env:` for a later function of ours to read, as a hand-off, a cache or a flag: the value is
returned and passed on as a parameter, and a cache lives in `$script:` state.
