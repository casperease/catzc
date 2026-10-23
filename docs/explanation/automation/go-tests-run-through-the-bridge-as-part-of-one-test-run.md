---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GO-LANGUAGEBRIDGE
      - ADR-AUTO-TEST-TESTRUN
---

# Go tests run through the bridge as part of one test run

This article is one rule: [ADR-AUTO-GO-LANGUAGEBRIDGE](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-languagebridge) and
[ADR-AUTO-TEST-TESTRUN](../../drs/automation/test-automation.md#rule-adr-auto-test-testrun) merged into one. It holds nothing beyond what
those two rules say.

`Test-Automation` runs the Go tests through a bridge, mapping each Go test module to its catzc module and turning every top-level Go test
into one test of the run. A test run is one invocation of a test entry point, `Test-Automation`, `Test-CatzcBuild` or `Invoke-TestFile`,
over one selection of test files: it claims one location, runs the selection once and records it in one report under `out/`.
