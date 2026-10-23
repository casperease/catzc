---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-ADDTYPECOMPILES
      - ADR-BCL-TYPES-ONEASSEMBLY
---

# Add type compiles the one assembly from every modules types

This article is one rule:
[ADR-PWSH-TYPES-ADDTYPECOMPILES](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-addtypecompiles) and
[ADR-BCL-TYPES-ONEASSEMBLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-oneassembly) merged into one. It holds
nothing beyond what those two rules say.

Every module's `types/*.cs` compile together into one assembly for the whole repository, so a type in any module can reference a type in any
other, only cross-namespace references inside a single assembly, never cross-assembly. `Add-Type` is the one runtime compiler of that
combined assembly: `Import-CSharpTypes` compiles the sources as authored with `Add-Type -Path`, one compilation unit per file.
