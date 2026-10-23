---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX
      - ADR-PWSH-ENGINE-PWSHISANENGINE
---

# An importer entry exists only when its engine in mix and pwsh one of three (ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX + ADR-PWSH-ENGINE-PWSHISANENGINE)

This article is one rule: [ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX](../../drs/automation/importer.md#rule-adr-auto-importer-entriesfollowmix) and
[ADR-PWSH-ENGINE-PWSHISANENGINE](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-pwshisanengine) merged into one. It holds
nothing beyond what those two rules say.

An engine's importer entry is generated only when one of the engines it serves is in the mix, so `importer.sh` exists only with a POSIX
engine. pwsh is one of the three execution engines, the one every catzc module runs under: PowerShell 7.4 or later on Windows, Linux and
macOS, and `Invoke-Importer` refuses an older PowerShell before anything loads.
