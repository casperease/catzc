---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-TYPES-ONEINSTANCEPERSESSION
      - ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES
---

# A session is bound to one types instance and every lasting change is announced

This article is one rule:
[ADR-PWSH-TYPES-ONEINSTANCEPERSESSION](../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-oneinstancepersession) and
[ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)
merged into one. It holds nothing beyond what those two rules say.

A pwsh session is bound to one types instance: the `Catzc.Types.<hash>.dll` it loaded first is the one it runs on until it exits, and no
janitor stops a process that holds a superseded build, waits for it or throws over it. Every lasting change a function makes to the state of
the session is announced on the always-shown status output, where it happens, naming what changed and to what.
