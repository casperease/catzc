---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Get-TestTargetSkipReason.ps1.md
    kind: comment-page
    body_sha: ce90d9bc3547
    adrs:
      - ADR-AUTO-TEST#41
      - ADR-AUTO-TEST#8
    links: []
---

# automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
An L4 test checks the released system itself, after final approval
([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)). It may run anywhere, a devbox
included: the only limit is the security context of the console running it. So each L4 test asks here first
and self-skips with the answer ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)):
  - target_<environment>_unreachable — the probe says this console's identity cannot reach the environment
    (or the probe throws);
  - target_<environment>_readonly    — the test needs synthetic transactions, but test-policy.yml lets the
    environment take read-only probes only (the default for an environment it does not list).
The answer is a constrained skip key: the environment name is lowercased with every character but a letter or
digit dropped (pre-prod -> preprod). A console run of L4 tests is a run of that gate outside its pipeline:
information, never a gate verdict.
```

## comment:2

Section `.PARAMETER Mode` of the comment-based help.

```text
How far the test changes the target: ReadOnly (probes and observations) or Synthetic (transactions the
system accepts and cleans up).
```

## comment:3

Section `.PARAMETER Probe` of the comment-based help.

```text
Answers whether this console's identity can reach the environment: a script block returning $true when it
can. A probe that throws counts as unreachable.
```
