---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IMPORTER-ONEENTRY
      - ADR-PWSH-ENGINE-STRICTMODELATEST
---

# The importer is the one entry and every scope runs in latest strict mode

This article is one rule: [ADR-AUTO-IMPORTER-ONEENTRY](../../drs/automation/importer.md#rule-adr-auto-importer-oneentry) and
[ADR-PWSH-ENGINE-STRICTMODELATEST](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-strictmodelatest) merged into one. It holds
nothing beyond what those two rules say.

The importer is the one way catzc enters a session: per execution engine one entry at the repository root, every entry generated from one
source and never hand-edited. Every PowerShell scope catzc owns runs under `Set-StrictMode -Version Latest`, because strict mode belongs to
a PowerShell scope and a session-level setting does not reach module code.
