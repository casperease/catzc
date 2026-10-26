/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-reports/types/CheckMode.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.Reports;

// Gate is the zero value, so a check whose config omits its mode fails on its findings rather than quietly reporting them.
public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
