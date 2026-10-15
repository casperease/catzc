---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md
    kind: reference
    body_sha: f1f7616772cc
    adrs:
      - ADR-AUTO-TEST#13
      - ADR-AUTO-TEST#41
---

# automation/Catzc.Base.Timeouts/types/TestTiers.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Timeouts;`.

```text
The test tiers, once: the tier tags a test may carry and the top tier a run includes by default
([ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13),
[ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)). The test run's tag check, run-scope filters and
timing report, and timeouts.yml's per-tier limits all read this list, so adding a tier is one edit. It lives with the
time safeguards because their config validates the tier keys and sits below the test tooling in the dependency graph.
```

## comment:2

Above `public static readonly string[] Names = { "L0", "L1", "L2", "L3", "L4" };`.

```text
Every tier tag, lowest first: L0/L1 the code alone, L2 local tools, L3 state outside the repository, L4 the released
system itself, after final approval.
```
