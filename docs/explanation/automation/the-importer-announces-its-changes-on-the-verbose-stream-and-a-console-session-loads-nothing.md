---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE
      - ADR-BCL-TYPES-CONSOLEVERIFIESONLY
---

# The importer announces its changes on the verbose stream and a console session loads nothing

This article is one rule:
[ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)
and [ADR-BCL-TYPES-CONSOLEVERIFIESONLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consoleverifiesonly) merged into
one. It holds nothing beyond what those two rules say.

The importer's own load sequence is the load-sequence exception: the state changes it makes itself are announced on the verbose stream. In a
console session it verifies the types assembly and loads nothing, `Import-CSharpTypes` registering the assembly as deferred and the first
lookup of a catzc command loading it, so an import that runs no command pays no load.
