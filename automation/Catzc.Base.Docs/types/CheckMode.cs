/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/CheckMode.cs
    kind: csharp-type
    module: Catzc.Base.Docs
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#4
---
*/

// Gate is the zero value, so a check whose config omits mode fails on findings; Report is the opt-in while its work list drains.
// [comment:1](/docs/references/automation/catzc-base-docs/types/CheckMode.cs.md#comment1)

namespace Catzc.Base.Docs;

public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
