---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-USEPS-SCRIPTFILESFORFUNCTIONS
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# Module function files are ps1 so they share state and a bundle carries merged manifests

This article is one rule:
[ADR-PWSH-USEPS-SCRIPTFILESFORFUNCTIONS](../../drs/automation/pwsh/use-ps1-not-psm1.md#rule-adr-pwsh-useps-scriptfilesforfunctions) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

Use `.ps1` for all module function files: dot-sourced into the module's session state by the module's loader, they share it, so public and
private functions see each other without imports. A bundle carries the runtime payload in merged form, every selected module its own folder
holding a generated `<Module>.psd1` whose `NestedModules` is the one merged file and whose `FunctionsToExport` is the module's public
functions only.
