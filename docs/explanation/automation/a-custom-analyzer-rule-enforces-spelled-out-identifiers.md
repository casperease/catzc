---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-NAMES-ANALYZERRULE
      - ADR-AUTO-SPELL-FULLWORDIDENTIFIERS
---

# A custom analyzer rule enforces spelled out identifiers (ADR-PWSH-NAMES-ANALYZERRULE + ADR-AUTO-SPELL-FULLWORDIDENTIFIERS)

This article is one rule: [ADR-PWSH-NAMES-ANALYZERRULE](../../drs/automation/pwsh/identifier-names.md#rule-adr-pwsh-names-analyzerrule) and
[ADR-AUTO-SPELL-FULLWORDIDENTIFIERS](../../drs/automation/spell-out-names.md#rule-adr-auto-spell-fullwordidentifiers) merged into one. It
holds nothing beyond what those two rules say.

Identifiers use full, spelled-out words, with no truncated words, no dropped vowels and no locally-invented acronyms. A custom
PSScriptAnalyzer rule, `Measure-SpellOutIdentifiers`, is the automatic identifier-level enforcer: it tokenizes every variable reference,
assignment targets, parameters, loop variables and reads, and the noun of every function name.
