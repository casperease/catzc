---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT
      - ADR-PWSH-ENGINE-IMPORTERDOTSOURCED
---

# Every console write goes through the information stream and the importer is dot sourced

This article is one rule:
[ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)
and [ADR-PWSH-ENGINE-IMPORTERDOTSOURCED](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-importerdotsourced) merged into one.
It holds nothing beyond what those two rules say.

Every write to the console goes through the information stream, by way of the writer chokepoint: `Write-Message` to
`Write-InformationColored` to `Write-Information`, or the loader's `Write-ImporterMessage` before the Writers module is loaded.
`importer.ps1` is always dot-sourced, so it runs in the caller's scope and its session state lands in the caller's session; it is a
generated shim that delegates the whole load sequence to `Invoke-Importer`.
