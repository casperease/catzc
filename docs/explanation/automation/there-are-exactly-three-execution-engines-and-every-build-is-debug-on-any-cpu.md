---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENGINE-THREEENGINES
      - ADR-BCL-TYPES-DEBUGANYCPU
---

# There are exactly three execution engines and every build is debug on any cpu

This article is one rule: [ADR-AUTO-ENGINE-THREEENGINES](../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines) and
[ADR-BCL-TYPES-DEBUGANYCPU](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-debuganycpu) merged into one. It holds
nothing beyond what those two rules say.

An execution engine is a shell the repository's own code runs under, and there are exactly three: pwsh, bash and zsh, declared once in the
`ExecutionEngines` model. In the same closed spirit, every non-vendored `.sln` and `.csproj` declares exactly one build configuration and
platform, Debug on Any CPU, and every `dotnet` call a catzc command makes builds that pair.
