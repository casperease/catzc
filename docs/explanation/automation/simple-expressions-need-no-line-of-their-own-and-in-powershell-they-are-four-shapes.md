---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-FORMAT-SIMPLEEXPRESSIONS
      - ADR-AUTO-NONEST-SIMPLEEXPRESSIONSEXEMPT
---

# Simple expressions need no line of their own and in powershell they are four shapes (ADR-PWSH-FORMAT-SIMPLEEXPRESSIONS + ADR-AUTO-NONEST-SIMPLEEXPRESSIONSEXEMPT)

This article is one rule:
[ADR-PWSH-FORMAT-SIMPLEEXPRESSIONS](../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-simpleexpressions) and
[ADR-AUTO-NONEST-SIMPLEEXPRESSIONSEXEMPT](../../drs/automation/avoid-deep-nesting.md#rule-adr-auto-nonest-simpleexpressionsexempt) merged
into one. It holds nothing beyond what those two rules say.

Simple expressions are exempt from the nesting limit: operations that cannot fail in surprising ways do not need their own line. In
PowerShell those are a `Join-Path` onto an anchor, a single property access such as `$moduleDir.Name`, a straightforward cast, and a short
pipeline of two obvious stages such as `Get-ChildPath … | Sort-Object`.
