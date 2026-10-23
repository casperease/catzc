---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT
      - ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES
---

# Console writes use the information stream and every lasting change is announced

This article is one rule:
[ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)
and [ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)
merged into one. It holds nothing beyond what those two rules say.

Every write to the console goes through the information stream, by way of the writer chokepoint, and nothing calls `Write-Host` or
`Out-Host`. Every lasting change a function makes to the state of the session is announced on the always-shown status output, where it
happens, naming what changed and to what.
