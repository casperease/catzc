---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-TESTRUN
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# A test run claims one location and the build is content addressed

This article is one rule: [ADR-AUTO-TEST-TESTRUN](../../drs/automation/test-automation.md#rule-adr-auto-test-testrun) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A test run is one invocation of a test entry point, `Test-Automation`, `Test-CatzcBuild` or `Invoke-TestFile`, over one selection of test
files: it claims one location, runs the selection once and records it in one report under `out/`. The build it exercises is immutable and
content-addressed, the same commit yielding a byte-identical build on any machine.
