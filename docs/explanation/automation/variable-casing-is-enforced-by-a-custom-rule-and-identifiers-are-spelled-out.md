---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-FORMAT-VARIABLECASING
      - ADR-PWSH-NAMES-ANALYZERRULE
---

# Variable casing is enforced by a custom rule and identifiers are spelled out

This article is one rule:
[ADR-PWSH-FORMAT-VARIABLECASING](../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-variablecasing) and
[ADR-PWSH-NAMES-ANALYZERRULE](../../drs/automation/pwsh/identifier-names.md#rule-adr-pwsh-names-analyzerrule) merged into one. It holds
nothing beyond what those two rules say.

Variable casing is PascalCase for parameters and scoped variables and camelCase for locals, enforced by the custom `Measure-VariableCasing`
rule, with scriptblock params and automatic variables excluded. A second custom PSScriptAnalyzer rule, `Measure-SpellOutIdentifiers`,
enforces spelled-out identifiers, tokenizing every variable reference and the noun of every function name.
