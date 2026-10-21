/*
---
catzc:
  immutable:
    with_body_sha: d971606a51e6
  edges:
    docs: "[CheckMode.cs.md](docs/references/pwsh/catzc-base-docs/types/CheckMode.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-QUALITYGATE
      - PDR-CONFIG-EXCEPTIONISCONFIGENTRY
---
*/

namespace Catzc.Base.Docs;

public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
