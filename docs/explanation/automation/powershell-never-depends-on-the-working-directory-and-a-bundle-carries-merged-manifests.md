---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PWD-NEVERDEPENDONPWD
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# Powershell never depends on the working directory and a bundle carries merged manifests

This article is one rule:
[ADR-PWSH-PWD-NEVERDEPENDONPWD](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-neverdependonpwd) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

PowerShell code never depends on the working directory and applies that with two anchors, the code root for a module's own content and the
dot-prefixed infrastructure, and the working root. A bundle carries the runtime payload in merged form, every selected module its own folder
holding a generated `<Module>.psd1`.
