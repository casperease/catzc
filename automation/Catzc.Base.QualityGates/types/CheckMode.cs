// How a source check treats what it finds, set per check in its config (SourceCheck), never per check in code
// ([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)):
//   Gate   — every finding is an issue, so the gate fails until the count is 0 (the default)
//   Report — every finding is printed and counted, and the run never fails on it; a check starts here while its
//            work list is drained, and returns to Gate once its count reaches 0

namespace Catzc.Base.QualityGates;

public enum CheckMode
{
    Gate,
    Report,
}
