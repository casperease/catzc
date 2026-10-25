/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-timeouts/types/TestTiers.cs.md"
  warning: "Generated Header"
---
*/

namespace Catzc.Base.Timeouts;

public static class TestTiers
{
    public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };

    // The highest tier number.
    public const int Highest = 4;

    // The top tier a run includes when it names none: L4 is opt-in, so a default run stops at L3.
    public const int DefaultTop = 3;

    public const int FirstRealProcessTier = 2;

    public const string BlockEveryLaunch = "1";
    public const string BlockByTier = "tier";
}
