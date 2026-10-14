// The test tiers, once: the tier tags a test may carry and the top tier a run includes by default
// ([ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13),
// [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)). The test run's tag check, run-scope filters and
// timing report, and timeouts.yml's per-tier limits all read this list, so adding a tier is one edit. It lives with the
// time safeguards because their config validates the tier keys and sits below the test tooling in the dependency graph.

namespace Catzc.Base.Timeouts;

public static class TestTiers
{
    // Every tier tag, lowest first: L0/L1 the code alone, L2 local tools, L3 state outside the repository, L4 the released
    // system itself, after final approval.
    public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };

    // The highest tier number.
    public const int Highest = 4;

    // The top tier a run includes when it names none: L4 is opt-in, so a default run stops at L3.
    public const int DefaultTop = 3;
}
