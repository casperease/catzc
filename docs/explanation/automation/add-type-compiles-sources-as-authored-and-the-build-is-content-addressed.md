---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-ADDTYPECOMPILES
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Add type compiles sources as authored and the build is content addressed

This article is one rule:
[ADR-PWSH-TYPES-ADDTYPECOMPILES](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-addtypecompiles) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

`Add-Type` is the one runtime compiler of the combined assembly: `Import-CSharpTypes` compiles the sources as authored with
`Add-Type -Path`, one compilation unit per file, because a file-scoped namespace is illegal once several files are concatenated into one
unit. The build is immutable and content-addressed: the same commit yields a byte-identical build on any machine, types DLL included, with
an identical durable-SHA content hash.
