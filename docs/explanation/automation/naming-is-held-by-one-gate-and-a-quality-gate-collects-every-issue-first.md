---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IDIOM-HELDBYGATE
      - ADR-AUTO-TEST-QUALITYGATE
---

# Naming is held by one gate and a quality gate collects every issue first (ADR-AUTO-IDIOM-HELDBYGATE + ADR-AUTO-TEST-QUALITYGATE)

This article is one rule: [ADR-AUTO-IDIOM-HELDBYGATE](../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-heldbygate) and
[ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) merged into one. It holds nothing beyond
what those two rules say.

A quality gate checks one property of the whole repository: one public `Test-<subject>` function that collects every issue, writes its
report through `Write-QualityGateReport`, and throws once listing them all. The naming is held the same way, by one gate and one assertion
over the tracked files: `Test-IdiomaticNames` reports each misnamed folder once per language and each misnamed file, function and type.
