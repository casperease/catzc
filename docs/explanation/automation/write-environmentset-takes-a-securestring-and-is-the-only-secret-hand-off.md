---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ENV-SECRETHANDOFF
      - ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS
---

# Write environmentset takes a securestring and is the only secret hand off

This article is one rule:
[ADR-PWSH-ENV-SECRETHANDOFF](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-secrethandoff) and
[ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../drs/automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess) merged into
one. It holds nothing beyond what those two rules say.

Handing a secret to a child or external process through the environment is a legitimate external-boundary use, permitted only through
`Write-EnvironmentSet`. That seam takes the secret as `[SecureString]`, masks it as `***` in everything it writes or returns, decrypts it
only when it sets the variable, and never logs or returns the plaintext.
