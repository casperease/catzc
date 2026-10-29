# pwsh/Base.Timeouts/types/TestTiers.cs

The test tiers, declared once: the tier tags a test may carry and the top tier a run includes by default
([ADR-AUTO-TEST-TWOMANDATORYTAGS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-twomandatorytags),
[ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../../drs/automation/test-automation.md#rule-adr-auto-test-testinginproduction)).

## One list, many readers

The test run's tag check, its tier filters and timing report, and `timeouts.yml`'s per-tier limits all read this list, so adding a tier is
one edit. It lives with the time safeguards because their config validates the tier keys and sits below the test tooling in the dependency
graph.

## The members

- `Names` lists every tier tag, lowest first: L0 and L1 the code alone, L2 local tools, L3 state outside the repository, L4 the released
  system itself, after final approval.
- `BlockEveryLaunch` and its sibling are the values of `CATZC_BLOCK_REAL_PROCESS`: every launch is blocked, or only a launch inside a
  container whose outermost tier is below `FirstRealProcessTier`. Any other value is an error.
- `FirstRealProcessTier` is the first tier that may launch a real process: L0 and L1, the tiers below it, launch none
  ([ADR-AUTO-TEST-PROCESSTRIPWIRE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-processtripwire)).

## comment:1

Above `public const int DefaultTop = 2;`, written with `//`.

```text
The top tier a run includes when it names none: L3, the live tier, and L4 are opt-in (-MaxLevel 3 or 4), so a default run stops at L2
([ADR-AUTO-NET-TESTSOFFLINE](/docs/drs/automation/network-calls.md#rule-adr-auto-net-testsoffline)).
```
