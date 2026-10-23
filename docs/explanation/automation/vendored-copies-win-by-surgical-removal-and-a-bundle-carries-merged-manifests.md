---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-MODPATH-SURGICALREMOVAL
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# Vendored copies win by surgical removal and a bundle carries merged manifests

This article is one rule:
[ADR-PWSH-MODPATH-SURGICALREMOVAL](../../drs/automation/pwsh/module-path-hygiene.md#rule-adr-pwsh-modpath-surgicalremoval) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

The vendored copy of every dependency wins by surgical removal, never a wholesale rebuild: `Import-VendorModules` unloads any non-vendored
copy, strips each vendored module's folders from `$env:PSModulePath` and prepends the `.vendor/` root. A bundle carries the runtime payload
in merged form, every selected module its own folder holding a generated `<Module>.psd1`.
