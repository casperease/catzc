/*
---
catzc:
  immutable:
    with_body_sha: "88c3cdfedb80"
  edges:
    docs: "[CheckMode.cs.md](../../../docs/references/pwsh/catzc-base-reports/types/CheckMode.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-QUALITYGATE
      - PDR-CONFIG-EXCEPTIONISCONFIGENTRY
---
*/

namespace Catzc.Base.Reports;

public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
