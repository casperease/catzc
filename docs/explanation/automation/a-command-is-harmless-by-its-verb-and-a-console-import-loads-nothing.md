---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ACCOSTED-HARMLESS
      - ADR-BCL-TYPES-CONSOLEVERIFIESONLY
---

# A command is harmless by its verb and a console import loads nothing

This article is one rule: [ADR-AUTO-ACCOSTED-HARMLESS](../../drs/automation/accosted-language.md#rule-adr-auto-accosted-harmless) and
[ADR-BCL-TYPES-CONSOLEVERIFIESONLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consoleverifiesonly) merged into one.
It holds nothing beyond what those two rules say.

A command is harmless when a command contract names it and its verb is on the harmless-verb list, declared once in the language's config
with its default on the config type. In a console session the importer verifies the types assembly and loads nothing: `Import-CSharpTypes`
registers the assembly as deferred, and the first lookup of a catzc command loads it.
