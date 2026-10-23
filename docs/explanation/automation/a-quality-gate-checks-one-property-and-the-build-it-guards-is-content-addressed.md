---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# A quality gate checks one property and the build it guards is content addressed

This article is one rule: [ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A quality gate is a gate, decided automatically, that checks one property of the whole repository or its declared scope: one public
`Test-<subject>` function that collects every issue, writes its report through `Write-QualityGateReport` and throws once listing them all.
The build is immutable and content-addressed: the same commit yields a byte-identical build on any machine and an identical durable-SHA
content hash.
