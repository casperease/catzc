---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEFAULT-ZEROARGUMENTCALL
      - ADR-AUTO-TEST-SYSTEMTESTSATLTHREE
---

# The zero argument call works and l3 tests depend on state outside the repository

This article is one rule:
[ADR-AUTO-DEFAULT-ZEROARGUMENTCALL](../../drs/automation/sensible-defaults.md#rule-adr-auto-default-zeroargumentcall) and
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../drs/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree) merged into one. It
holds nothing beyond what those two rules say.

The zero-argument call must work: if a function can do useful work without input, all parameters have defaults, so `Test-Automation` runs
every tier its location allows with detailed output. The tiers follow the state a test touches: L3 holds the vertical system tests, tests
that change or depend on state outside the repository such as the cloud, the user's environment or installed tools.
