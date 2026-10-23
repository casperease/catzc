---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GUIDS-NAMEKEYEDENTRY
      - ADR-AUTO-TEST-FILEPARALLELISM
---

# A guid registry entry is name keyed and a run shards whole files

This article is one rule: [ADR-AUTO-GUIDS-NAMEKEYEDENTRY](../../drs/automation/managed-guids.md#rule-adr-auto-guids-namekeyedentry) and
[ADR-AUTO-TEST-FILEPARALLELISM](../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism) merged into one. It holds
nothing beyond what those two rules say.

A GUID-registry entry is name-keyed and strict, `<snake_case_name>: { guid, description }`, with a canonical lowercase hyphenated GUID,
unique across entries, and unknown keys rejected. `Test-Automation` parallelizes at whole-file granularity across worker processes, each
worker loading the modules through its run's entry script and running its shard.
