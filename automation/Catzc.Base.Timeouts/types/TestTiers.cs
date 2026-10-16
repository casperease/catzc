/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/types/TestTiers.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md
      test: automation/Catzc.Base.Timeouts/tests/types/TestTiers.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{13,41}
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
