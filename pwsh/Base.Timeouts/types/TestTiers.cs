namespace Catzc.Base.Timeouts;

// The test tiers, once: the tier tags a test may carry and the top tier a run includes by default.
public static class TestTiers
{
    // Lowest first: L0/L1 the code alone, L2 local tools, L3 state outside the repository, L4 the released system after approval.
    public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };

    // The highest tier number.
    public const int Highest = 4;

    // The top tier a run includes when it names none: L4 is opt-in, so a default run stops at L3.
    public const int DefaultTop = 3;

    // The first tier that may launch a real process; L0 and L1 launch none.
    public const int FirstRealProcessTier = 2;

    // CATZC_BLOCK_REAL_PROCESS: every launch blocked, or only one in a container whose top tier is below FirstRealProcessTier.
    public const string BlockEveryLaunch = "1";
    public const string BlockByTier = "tier";
}
