---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md
    kind: comment-page
    body_sha: "5ef021d58394"
    adrs:
      - ADR-AUTO-XPLAT#6
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single place that turns the aggregated run facts (the test verdict, the failed-test count, failed-shard
labels, the timing verdict) into the two values the closing banner and the failure throw both consume: a
'Passed'/'Failed' Result — a timing-only or budget-only failure reads Failed even though the test verdict
passed — and a Summary reason: the counts-in-time on a pass, or the cause on a fail (failed tests, a failed
shard with no failed test row, a devbox run over its whole-run budget, or an -EnforceTimings over-limit).
Extracted from Test-Automation so the reason wording
lives once and the orchestrator stays a single, readable responsibility.
```

## comment:2

Above `$seconds = [math]::Round($DurationSeconds,...`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)) — a da-DK box would
otherwise render '42,3s' and diverge from CI's '42.3s'.
```

## comment:3

Above `$seconds = [math]::Round($DurationSeconds,...`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)) — a da-DK box would
otherwise render '42,3s' and diverge from CI's '42.3s'.
```
