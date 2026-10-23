---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-RESTARTTORELOAD
      - ADR-PWSH-ENGINE-STRICTMODELATEST
---

# Stale types need a new process and every scope runs in latest strict mode (ADR-PWSH-TYPES-RESTARTTORELOAD + ADR-PWSH-ENGINE-STRICTMODELATEST)

This article is one rule:
[ADR-PWSH-TYPES-RESTARTTORELOAD](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-restarttoreload) and
[ADR-PWSH-ENGINE-STRICTMODELATEST](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-strictmodelatest) merged into one. It holds
nothing beyond what those two rules say.

A loaded assembly cannot be unloaded from the pwsh process, so the only remedy for stale types is a new pwsh process, and the loader's
devbox warning names that remedy. Strictness is likewise set where the code runs: every PowerShell scope catzc owns runs under
`Set-StrictMode -Version Latest`, because strict mode belongs to a scope and a session-level setting does not reach module code.
