# pwsh/Catzc.Base.Timeouts/types/TestTiers.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Timeouts;`, written with `//`.

```text
The test tiers, once: the tier tags a test may carry and the top tier a run includes by default
([ADR-AUTO-TEST-TWOMANDATORYTAGS](/docs/drs/automation/test-automation.md#rule-adr-auto-test-twomandatorytags),
[ADR-AUTO-TEST-TESTINGINPRODUCTION](/docs/drs/automation/test-automation.md#rule-adr-auto-test-testinginproduction)). The test run's tag check, run-scope filters and
timing report, and timeouts.yml's per-tier limits all read this list, so adding a tier is one edit. It lives with the
time safeguards because their config validates the tier keys and sits below the test tooling in the dependency graph.
```

## comment:2

Above `public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };`, written with `//`.

```text
Every tier tag, lowest first: L0/L1 the code alone, L2 local tools, L3 state outside the repository, L4 the released
system itself, after final approval.
```

## comment:3

Above `public const string BlockEveryLaunch = "1";`, written with `//`.

```text
The values of CATZC_BLOCK_REAL_PROCESS: every launch is blocked, or only a launch inside a container whose outermost tier is below
FirstRealProcessTier. Any other value is an error.
```

## comment:4

Above `public const int FirstRealProcessTier = 2;`, written with `//`.

```text
The first tier that may launch a real process: L0 and L1, the tiers below it, launch none
([ADR-AUTO-TEST-PROCESSTRIPWIRE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-processtripwire)).
```
