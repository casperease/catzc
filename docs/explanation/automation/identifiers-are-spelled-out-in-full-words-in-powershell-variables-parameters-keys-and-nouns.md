---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-NAMES-POWERSHELLIDENTIFIERS
      - ADR-AUTO-SPELL-FULLWORDIDENTIFIERS
---

# Identifiers are spelled out in full words in powershell variables parameters keys and nouns (ADR-PWSH-NAMES-POWERSHELLIDENTIFIERS + ADR-AUTO-SPELL-FULLWORDIDENTIFIERS)

This article is one rule:
[ADR-PWSH-NAMES-POWERSHELLIDENTIFIERS](../../drs/automation/pwsh/identifier-names.md#rule-adr-pwsh-names-powershellidentifiers) and
[ADR-AUTO-SPELL-FULLWORDIDENTIFIERS](../../drs/automation/spell-out-names.md#rule-adr-auto-spell-fullwordidentifiers) merged into one. It
holds nothing beyond what those two rules say.

Identifiers use full, spelled-out words: write `protocols`, not `protos`; `templateFolderPath`, not `tfPath`; `stringBuilder`, not `sb`,
with no truncated words, no dropped vowels and no locally-invented acronyms. In PowerShell the identifiers this covers are variable names,
parameter names such as `-TemplateFolderPath`, hashtable keys and the noun of a `Verb-Noun` function name.
