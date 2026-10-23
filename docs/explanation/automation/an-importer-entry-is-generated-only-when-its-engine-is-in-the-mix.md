---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX
      - ADR-AUTO-ENGINE-IMPORTERENTRY
---

# An importer entry is generated only when its engine is in the mix

This article is one rule: [ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX](../../drs/automation/importer.md#rule-adr-auto-importer-entriesfollowmix) and
[ADR-AUTO-ENGINE-IMPORTERENTRY](../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry) merged into one. It holds
nothing beyond what those two rules say.

An engine's importer entry is generated only when one of the engines it serves is in the mix: `importer.sh` only with a POSIX engine. Each
engine reaches catzc through its importer entry at the repository root, and the POSIX engines share that one generated, committed root file,
which each of them loads into its session, with no copy per shell. Which engines an entry serves comes from the engine model's importer
entry, so the fact lives once.
