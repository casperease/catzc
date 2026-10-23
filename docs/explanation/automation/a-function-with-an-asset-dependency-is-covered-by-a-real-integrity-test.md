---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-AUTO-TEST-ONECATEGORY
---

# A function with an asset dependency is covered by a real integrity test

This article is one rule:
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest) and
[ADR-AUTO-TEST-ONECATEGORY](../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory) merged into one. It holds nothing beyond
what those two rules say.

Every function with an internal asset dependency is covered by at least one test that reads the real asset, carries the citation tag
`ADR-AUTO-ASSETDEP-COVEREDBYREALTEST` and is not tagged `source-only`, so it runs in both the source run and the build run. Because it reads
a shipped asset it is an integrity test: every test is classified into exactly one category, logic or integrity, and a logic test must not
read a shipped asset.
