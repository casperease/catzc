---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-OVERLAY-OVERLAYFOLDER
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# The overlay is only place a consumer changes a bundle and bundle carries merged manifests

This article is one rule: [ADR-AUTO-OVERLAY-OVERLAYFOLDER](../../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-overlayfolder) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

A consumer's overlay is the `.catzc/` folder at its `RepositoryRoot`: the only place a consumer changes what a built bundle does. The bundle
it runs is read-only and never edited, and it carries the runtime payload in merged form, every selected module its own folder holding a
generated `<Module>.psd1`.
