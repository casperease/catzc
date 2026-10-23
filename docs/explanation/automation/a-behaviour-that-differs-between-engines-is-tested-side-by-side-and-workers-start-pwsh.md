---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENGINE-SIDEBYSIDETESTS
      - ADR-PWSH-ENGINE-CHILDPROCESSES
---

# A behaviour that differs between engines is tested side by side and workers start pwsh

This article is one rule: [ADR-AUTO-ENGINE-SIDEBYSIDETESTS](../../drs/automation/execution-engines.md#rule-adr-auto-engine-sidebysidetests)
and [ADR-PWSH-ENGINE-CHILDPROCESSES](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-childprocesses) merged into one. It holds
nothing beyond what those two rules say.

A behaviour that differs between the engines is tested side by side, in a per-engine fixture table: one row per case, one column per engine,
pwsh, bash and zsh, every column filled or naming why the case does not apply (`n/a: <reason>`). The Pester workers of a test run, the
isolated runs of `Test-InIsolation` and the snapshot priming each start a child pwsh, because Pester is a PowerShell framework.
