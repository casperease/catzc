/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/types/TestTiers.cs
    kind: type
    module: Catzc.Base.Timeouts
    adrs:
      - ADR-AUTO-TEST#13
      - ADR-AUTO-TEST#41
---
*/

// It lives here because the timeout config validates the tier keys and sits below the test tooling in the dependency graph.
// [ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13),
// [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)
// [comment:1](/docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md#comment1)

namespace Catzc.Base.Timeouts;

public static class TestTiers
{
    // Order matters, lowest first: L4 alone runs against the released system after final approval, so a default run stops below it.
    // [comment:2](/docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md#comment2)
    public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };

    // The highest tier number.
    public const int Highest = 4;

    // The top tier a run includes when it names none: L4 is opt-in, so a default run stops at L3.
    public const int DefaultTop = 3;
}
