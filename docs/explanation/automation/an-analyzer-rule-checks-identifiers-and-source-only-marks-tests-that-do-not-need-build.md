---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-NAMES-ANALYZERRULE
      - ADR-AUTO-TEST-SOURCEONLYTAG
---

# An analyzer rule checks identifiers and source only marks tests that do not need build

This article is one rule: [ADR-PWSH-NAMES-ANALYZERRULE](../../drs/automation/pwsh/identifier-names.md#rule-adr-pwsh-names-analyzerrule) and
[ADR-AUTO-TEST-SOURCEONLYTAG](../../drs/automation/test-automation.md#rule-adr-auto-test-sourceonlytag) merged into one. It holds nothing
beyond what those two rules say.

A custom PSScriptAnalyzer rule, `Measure-SpellOutIdentifiers`, is the automatic identifier-level enforcer of the spelling rule, tokenizing
every variable reference and the noun of every function name. `source-only` is the one tag by which a test opts out of the build run: it
marks a test whose answer cannot differ between the modes, an integrity test that reads only the repository's files, or a logic test of a
source-tree tool.
