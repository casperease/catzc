---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED
      - ADR-PWSH-PWD-MODULELOCATESCONTENT
---

# Generated manifests are gitignored and module code locates its own content

This article is one rule:
[ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-manifestsgitignored)
and [ADR-PWSH-PWD-MODULELOCATESCONTENT](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-modulelocatescontent)
merged into one. It holds nothing beyond what those two rules say.

Generated manifests are gitignored, never committed: `New-DynamicManifest` recomputes each module's `<Module>.psd1` on every import, so
`pwsh/**/*.psd1` is a pure derived artifact. Module code locates its own content, its `configs/`, its `assets/`, another module's and the
dot-prefixed infrastructure, through the code-root helpers.
