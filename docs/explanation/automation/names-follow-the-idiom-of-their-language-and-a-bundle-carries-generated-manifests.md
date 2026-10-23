---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IDIOM-LANGUAGEIDIOM
      - ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS
---

# Names follow the idiom of their language and a bundle carries generated manifests

This article is one rule: [ADR-AUTO-IDIOM-LANGUAGEIDIOM](../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-languageidiom) and
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)
merged into one. It holds nothing beyond what those two rules say.

Every source file, folder, function and type is named in the idiom of its language, and the idiom is configuration: each language's entry
carries a `naming:` map. A bundle carries the runtime payload in merged form: every selected module is its own folder holding a generated
`<Module>.psd1` whose `NestedModules` is the one merged file and whose `FunctionsToExport` is the module's public functions only.
