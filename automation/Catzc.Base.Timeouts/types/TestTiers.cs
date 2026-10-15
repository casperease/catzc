// The test tiers, once: the tier tags a test may carry and the top tier a run includes by default.
// [ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13),
// [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)
// [comment:1](/docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md#comment1)

namespace Catzc.Base.Timeouts;

public static class TestTiers
{
    // Every tier tag, lowest first: L0/L1 the code alone, L2 local tools, L3 state outside the repository, L4 the released system...
    // [comment:2](/docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md#comment2)
    public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };

    // The highest tier number.
    public const int Highest = 4;

    // The top tier a run includes when it names none: L4 is opt-in, so a default run stops at L3.
    public const int DefaultTop = 3;
}
