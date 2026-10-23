---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PWD-MODULELOCATESCONTENT
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# Module code locates its own content and a bundle carries merged manifests

This article is one rule:
[ADR-PWSH-PWD-MODULELOCATESCONTENT](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-modulelocatescontent) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

Module code locates its own content, its `configs/`, its `assets/`, another module's, and the dot-prefixed infrastructure (`.internal/`,
`.vendor/`, `.compiled/`), through the code-root helpers. A bundle carries the runtime payload in merged form, every selected module its own
folder holding a generated `<Module>.psd1`.
