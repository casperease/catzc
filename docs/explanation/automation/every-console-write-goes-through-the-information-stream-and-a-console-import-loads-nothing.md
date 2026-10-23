---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT
      - ADR-BCL-TYPES-CONSOLEVERIFIESONLY
---

# Every console write goes through the information stream and a console import loads nothing

This article is one rule:
[ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)
and [ADR-BCL-TYPES-CONSOLEVERIFIESONLY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consoleverifiesonly) merged into
one. It holds nothing beyond what those two rules say.

Every write to the console goes through the information stream, by way of the writer chokepoint `Write-Message` to
`Write-InformationColored` to `Write-Information`, or the loader's `Write-ImporterMessage` before the Writers module is loaded. In a console
session the importer verifies the types assembly and loads nothing, so an import that runs no command pays no load.
