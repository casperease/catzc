/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/CheckMode.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/types/CheckMode.cs.md
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#4
---
*/

namespace Catzc.Base.Docs;

public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
