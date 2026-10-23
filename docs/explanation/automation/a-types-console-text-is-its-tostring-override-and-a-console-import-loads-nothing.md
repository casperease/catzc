---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-TOSTRINGOVERRIDE
      - ADR-BCL-TYPES-CONSOLEVERIFIESONLY
---

# A types console text is its tostring override and a console import loads nothing

This article is one rule:
[ADR-PWSH-TYPES-TOSTRINGOVERRIDE](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-tostringoverride) and
[ADR-BCL-TYPES-CONSOLEVERIFIESONLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consoleverifiesonly) merged into one.
It holds nothing beyond what those two rules say.

The console-ready text of a type is its C# `ToString()` override, because pwsh's string interpolation and `[string]` cast call the .NET
`ToString()` and ignore a `ToString` registered through the extended type system. In a console session the importer verifies the types
assembly and loads nothing, `Import-CSharpTypes` registering it as deferred until the first catzc command is looked up.
