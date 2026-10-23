---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-TESTSUITE
      - ADR-AUTO-GO-LANGUAGEBRIDGE
---

# A test suite is a declared selection and go tests run through the bridge

This article is one rule: [ADR-AUTO-TEST-TESTSUITE](../../drs/automation/test-automation.md#rule-adr-auto-test-testsuite) and
[ADR-AUTO-GO-LANGUAGEBRIDGE](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-languagebridge) merged into one. It holds nothing
beyond what those two rules say.

A test suite is a named, declared selection of tests that runs as one unit, a set of modules and a top tier declared in configuration rather
than typed at a prompt: a globset's `verify:` scope in `globs.yml`. `Test-Automation` runs the Go tests through a bridge that maps each Go
test module to its catzc module, so `-Modules`, `-Suite`, the tiers and both runs apply as to the module's own tests.
