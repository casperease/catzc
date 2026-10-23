---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-TESTINGINPRODUCTION
      - ADR-BCL-TYPES-CONSOLEVERIFIESONLY
---

# Testing in production is l4 and a console session loads types on first use

This article is one rule:
[ADR-AUTO-TEST-TESTINGINPRODUCTION](../../drs/automation/test-automation.md#rule-adr-auto-test-testinginproduction) and
[ADR-BCL-TYPES-CONSOLEVERIFIESONLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consoleverifiesonly) merged into one.
It holds nothing beyond what those two rules say.

Testing in production is the L4 tier: tests of the released system itself, after final approval, where the release-candidate artifact that
cleared the RBC gate runs, pre-prod and then production once activated; it is the only tier that reaches a serving environment. Cost at
import is kept low the other way round: in a console session the importer verifies the types assembly and loads nothing, and the first
lookup of a catzc command loads it.
