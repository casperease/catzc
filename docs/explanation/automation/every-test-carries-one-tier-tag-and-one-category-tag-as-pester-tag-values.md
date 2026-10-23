---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PESTER-TAGVALUES
      - ADR-AUTO-TEST-TWOMANDATORYTAGS
---

# Every test carries one tier tag and one category tag as pester tag values

This article is one rule: [ADR-PWSH-PESTER-TAGVALUES](../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-tagvalues) and
[ADR-AUTO-TEST-TWOMANDATORYTAGS](../../drs/automation/test-automation.md#rule-adr-auto-test-twomandatorytags) merged into one. It holds
nothing beyond what those two rules say.

Every test carries two mandatory, orthogonal tags: exactly one tier, `L0|L1|L2|L3|L4`, and exactly one category, `logic|integrity`, with no
default for either; a test resolving to zero or to two of the same axis is a violation. In Pester they are `-Tag` values: put both on the
`Describe` for a uniform file, and override on an inner `Context` where tiers or categories differ, never two tags of the same axis on one
block.
