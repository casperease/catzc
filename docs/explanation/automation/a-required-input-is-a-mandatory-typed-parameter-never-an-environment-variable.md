---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENVVAR-NEVERREQUIRED
      - ADR-PWSH-ENV-REQUIREDINPUTISPARAMETER
---

# A required input is a mandatory typed parameter never an environment variable

This article is one rule: [ADR-AUTO-ENVVAR-NEVERREQUIRED](../../drs/automation/environment-variables.md#rule-adr-auto-envvar-neverrequired)
and
[ADR-PWSH-ENV-REQUIREDINPUTISPARAMETER](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-requiredinputisparameter)
merged into one. It holds nothing beyond what those two rules say.

Never require an environment variable to be set for a function to work: the function signature is the contract, not a hidden environment
variable. A required input is a `[Parameter(Mandatory)]` parameter, typed and validated with `[ValidateSet()]` or `[ValidateRange()]`, and
never a guard that throws when a `$env:` variable is unset.
