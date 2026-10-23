---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PWD-NEVERDEPENDONPWD
      - ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY
---

# Powershell code never depends on the working directory and internal assets have one locator

This article is one rule:
[ADR-PWSH-PWD-NEVERDEPENDONPWD](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-neverdependonpwd) and
[ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)
merged into one. It holds nothing beyond what those two rules say.

PowerShell code never depends on the working directory and applies that with two anchors, the code root (`Get-CatzcModuleRoot` for a
module's own content, `Get-CatzcModulesRoot` for the dot-prefixed infrastructure) and the working root. An internal asset dependency is any
read, by a module's own code, of content that ships inside the code tree: the module's `configs/` and `assets/`, another module's,
`.internal/assets/`, `.vendor/` and `.compiled/`, located only through the code-root helper.
