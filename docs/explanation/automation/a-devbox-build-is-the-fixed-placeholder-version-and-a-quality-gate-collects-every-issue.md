---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BUNDLE-AUTOVERSION
      - ADR-AUTO-TEST-QUALITYGATE
---

# A devbox build is the fixed placeholder version and a quality gate collects every issue

This article is one rule: [ADR-AUTO-BUNDLE-AUTOVERSION](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-autoversion) and
[ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) merged into one. It holds nothing beyond
what those two rules say.

`Build-Modules -Version` defaults to `auto`, resolved by `Resolve-CatzcBuildVersion`: a devbox (source-mode) build is the fixed `6.6.666`
placeholder, announced by a yellow `Write-Message` notice that real versions come only from the pipeline. A quality gate is the matching
discipline for checks: one public `Test-<subject>` function that collects every issue, writes its report through `Write-QualityGateReport`
and throws once listing them all.
