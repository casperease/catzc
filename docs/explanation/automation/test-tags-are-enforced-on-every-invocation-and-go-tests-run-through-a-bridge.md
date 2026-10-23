---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-TAGSENFORCED
      - ADR-AUTO-GO-LANGUAGEBRIDGE
---

# Test tags are enforced on every invocation and go tests run through a bridge

This article is one rule: [ADR-AUTO-TEST-TAGSENFORCED](../../drs/automation/test-automation.md#rule-adr-auto-test-tagsenforced) and
[ADR-AUTO-GO-LANGUAGEBRIDGE](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-languagebridge) merged into one. It holds nothing
beyond what those two rules say.

`Test-Automation` enforces the two mandatory tags on every invocation: a discovery-only pass, `Get-TestTagViolations`, inspects every test
regardless of `-Level` and the run throws if any test is missing, or ambiguous on, a tier or category tag. Go tests run through a bridge:
discovery maps each Go test module to its catzc module, so ordering, protection, the tiers and both runs apply as to the module's own tests.
