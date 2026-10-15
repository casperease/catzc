// Gate is the zero value, so a check whose config omits mode fails on findings; Report is the opt-in while its work list drains.
// [ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4),
// [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
// [comment:1](/docs/references/automation/catzc-base-docs/types/CheckMode.cs.md#comment1)

namespace Catzc.Base.Docs;

public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
