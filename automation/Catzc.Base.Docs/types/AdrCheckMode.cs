// How an ADR check (configs/adr-checks.yml) ends: Report prints every finding and their count and never fails the run; Gate fails the
// run like any quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). A check starts in
// Report while its findings are worked off and moves to Gate once their count is 0. The default is declared once, on
// AdrChecksConfig.DefaultMode ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).

namespace Catzc.Base.Docs;

public enum AdrCheckMode
{
    Report,
    Gate,
}
