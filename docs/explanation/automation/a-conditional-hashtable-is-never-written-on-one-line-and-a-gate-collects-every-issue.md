---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-FORMAT-MULTILINECONDITIONALHASHTABLE
      - ADR-AUTO-TEST-QUALITYGATE
---

# A conditional hashtable is never written on one line and a gate collects every issue

This article is one rule:
[ADR-PWSH-FORMAT-MULTILINECONDITIONALHASHTABLE](../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilineconditionalhashtable)
and [ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) merged into one. It holds nothing
beyond what those two rules say.

A hashtable literal that holds an `if`/`else` is written on several lines, or its value is bound to a local first, never written on one
line, because PSScriptAnalyzer's `Invoke-Formatter` throws on the one-line form. Since `Format-Code` and `Test-Formatting` format every file
in one pass, one such file stops the formatting gate, and a quality gate is a gate that collects every issue and throws once listing them
all.
