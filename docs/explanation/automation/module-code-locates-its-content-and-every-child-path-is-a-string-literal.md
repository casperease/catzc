---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PWD-MODULELOCATESCONTENT
      - ADR-AUTO-ASSETDEP-LITERALCHILDPATH
---

# Module code locates its content and every child path is a string literal

This article is one rule:
[ADR-PWSH-PWD-MODULELOCATESCONTENT](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-modulelocatescontent) and
[ADR-AUTO-ASSETDEP-LITERALCHILDPATH](../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-literalchildpath) merged
into one. It holds nothing beyond what those two rules say.

Module code locates its own content, its `configs/`, its `assets/`, another module's, and the dot-prefixed infrastructure, through the
code-root helpers. The child path is a string literal at every call site of the code-root helper, so the full set of internal asset
dependencies, one (module, function, child path) entry per call site, is derived from the code by `Get-InternalAssetDependency`: the code is
the registration, with no separate list to keep in step.
