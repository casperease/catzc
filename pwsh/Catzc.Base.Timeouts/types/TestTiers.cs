/*
---
catzc:
  immutable:
    with_body_sha: "9364a92af947"
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/types/TestTiers.Tests.ps1
    docs: "[TestTiers.cs.md](../../../docs/references/pwsh/catzc-base-timeouts/types/TestTiers.cs.md)"
    cites:
      - ADR-AUTO-TEST-TWOMANDATORYTAGS
      - ADR-AUTO-TEST-TESTINGINPRODUCTION
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
}
