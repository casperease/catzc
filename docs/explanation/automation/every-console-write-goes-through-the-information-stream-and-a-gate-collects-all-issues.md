---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT
      - ADR-AUTO-TEST-QUALITYGATE
---

# Every console write goes through the information stream and a gate collects all issues

This article is one rule:
[ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)
and [ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) merged into one. It holds nothing
beyond what those two rules say.

Every write to the console goes through the information stream, by way of the writer chokepoint `Write-Message` to
`Write-InformationColored` to `Write-Information`, or the loader's `Write-ImporterMessage` before the Writers module is loaded; nothing
calls `Write-Host` or `Out-Host`. A quality gate holds that property for the whole repository: one public `Test-<subject>` function that
collects every issue and throws once listing them all.
