---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-TOSTRINGOVERRIDE
      - ADR-BCL-TYPES-CONSOLEREADYTOSTRING
---

# A types console text is its csharp tostring override

This article is one rule:
[ADR-PWSH-TYPES-TOSTRINGOVERRIDE](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-tostringoverride) and
[ADR-BCL-TYPES-CONSOLEREADYTOSTRING](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consolereadytostring) merged into
one. It holds nothing beyond what those two rules say.

Every concrete type a caller can hold renders console-ready: it overrides `ToString()`, normally as the one line
`public override string ToString() => this.ToConsoleString();`, so its string form and a table cell read `TypeName { A = 1, B = x }` instead
of the fully-qualified name. The override is the C# `ToString()` because pwsh's string interpolation and `[string]` cast call the .NET
`ToString()` and ignore a `ToString` registered through the extended type system.
