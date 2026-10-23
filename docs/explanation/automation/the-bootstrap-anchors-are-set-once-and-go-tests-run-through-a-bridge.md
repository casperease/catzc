---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ENV-BOOTSTRAPANCHORS
      - ADR-AUTO-GO-LANGUAGEBRIDGE
---

# The bootstrap anchors are set once and go tests run through a bridge

This article is one rule:
[ADR-PWSH-ENV-BOOTSTRAPANCHORS](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-bootstrapanchors) and
[ADR-AUTO-GO-LANGUAGEBRIDGE](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-languagebridge) merged into one. It holds nothing
beyond what those two rules say.

The bootstrap anchors are `$env:RepositoryRoot` (the working root) and `$env:CatzcModulesRoot` (the code root), set once by the importer
entry. `Test-Automation` runs the Go tests through a bridge: discovery maps each Go test module to its catzc module, so ordering,
protection, the tiers and both runs apply as to the module's own tests, and the bridge turns every top-level Go test into one test of the
run.
