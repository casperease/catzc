---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-COLLAPSEINPUTCLUSTERS
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# A cluster of input only integration tests is collapsed into l0 logic tests

This article is one rule:
[ADR-AUTO-TEST-COLLAPSEINPUTCLUSTERS](../../drs/automation/test-automation.md#rule-adr-auto-test-collapseinputclusters) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

A cluster of slow integration tests that differ only by input, each re-proving the same cross-boundary wiring for a different case, is a
design signal, not a cost to accept: push the per-case assertions left into fast, deterministic, mocked L0 logic tests and leave the
integration tier a thin walking skeleton. A bundle, by contrast, carries the runtime payload in merged form.
