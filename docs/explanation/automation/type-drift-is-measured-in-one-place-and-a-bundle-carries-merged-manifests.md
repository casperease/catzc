---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
      - ADR-BCL-TYPES-ONEDRIFTMEASURE
---

# Type drift is measured in one place and a bundle carries merged manifests

This article is one rule:
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
and [ADR-BCL-TYPES-ONEDRIFTMEASURE](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-onedriftmeasure) merged into one. It
holds nothing beyond what those two rules say.

Whether the C# types loaded in a process are current is measured in one place, `Get-LoadedTypeDrift`, and asked through one test and assert
pair, `Test-LoadedTypesCurrent` and `Assert-LoadedTypesCurrent`. A bundle carries the runtime payload in merged form, every selected module
its own folder holding a generated `<Module>.psd1`.
