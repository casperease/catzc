---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-BUILDVERIFICATIONTEST
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# The build verification test precedes every promotion and a bundle carries merged manifests

This article is one rule:
[ADR-AUTO-TEST-BUILDVERIFICATIONTEST](../../drs/automation/test-automation.md#rule-adr-auto-test-buildverificationtest) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

The Build Verification Test is the verification that precedes every promotion and every creation of release artifacts, with one aggregate
verdict: it runs every selected test up to the target level together with the built-artifact checks of `Test-BuildArtifact`. A bundle
carries the runtime payload in merged form, every selected module its own folder holding a generated `<Module>.psd1`.
