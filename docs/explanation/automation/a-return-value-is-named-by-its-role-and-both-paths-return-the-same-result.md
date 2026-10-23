---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-NAMES-RETURNVALUEBYROLE
      - ADR-PWSH-IDEM-SAMERESULTBOTHPATHS
---

# A return value is named by its role and both paths return the same result

This article is one rule:
[ADR-PWSH-NAMES-RETURNVALUEBYROLE](../../drs/automation/pwsh/identifier-names.md#rule-adr-pwsh-names-returnvaluebyrole) and
[ADR-PWSH-IDEM-SAMERESULTBOTHPATHS](../../drs/automation/pwsh/idempotent-state-mechanics.md#rule-adr-pwsh-idem-sameresultbothpaths) merged
into one. It holds nothing beyond what those two rules say.

Name a function's return value by its role, not its type or contents, with one of two blessed conventional locals: `$ret`, the return
accumulator a function builds up and then hands back, and `$found`, the lookup result a search returns. Both paths of a pwsh state function
return the same result: the early `return $existing` and the end of the work path emit the same type, declared in `[OutputType()]`.
