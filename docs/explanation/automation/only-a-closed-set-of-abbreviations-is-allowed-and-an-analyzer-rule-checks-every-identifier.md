---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-SPELL-ALLOWEDABBREVIATIONS
      - ADR-PWSH-NAMES-ANALYZERRULE
---

# Only a closed set of abbreviations is allowed and an analyzer rule checks every identifier

This article is one rule:
[ADR-AUTO-SPELL-ALLOWEDABBREVIATIONS](../../drs/automation/spell-out-names.md#rule-adr-auto-spell-allowedabbreviations) and
[ADR-PWSH-NAMES-ANALYZERRULE](../../drs/automation/pwsh/identifier-names.md#rule-adr-pwsh-names-analyzerrule) merged into one. It holds
nothing beyond what those two rules say.

The only abbreviations allowed without spelling out are single-letter loop indices (`i`, `j`, `k`), the small set of universal,
industry-standard acronyms that are the canonical name for a thing (CSV, JSON, YAML, URL, URI, ID, HTTP, IP, UTC, API, CLI, DNS, TLS, SDK,
GUID, regex, UTF, BOM), and the engine's own automatic variables. A custom PSScriptAnalyzer rule, `Measure-SpellOutIdentifiers`, enforces
this automatically at identifier level, tokenizing every variable reference and the noun of every function name.
