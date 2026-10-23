---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-VENDOR-ONLYWHATLOADS
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# A vendored module carries only what loads and a bundle carries merged manifests (ADR-PWSH-VENDOR-ONLYWHATLOADS + ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS)

This article is one rule:
[ADR-PWSH-VENDOR-ONLYWHATLOADS](../../drs/automation/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor-onlywhatloads) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

A vendored module carries only what the toolset loads: folders it never loads are pruned at install time by `Install-VendorModule`, never by
hand, so a reinstall or upgrade reproduces the same trimmed copy. A bundle carries the runtime payload in merged form, each selected module
its own folder with a generated `<Module>.psd1`, `NestedModules` set to the one merged file.
