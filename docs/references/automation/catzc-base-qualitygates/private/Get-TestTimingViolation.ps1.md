---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestTimingViolation.ps1.md
    kind: reference
    body_sha: "518802341120"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestTimingViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Validates the aggregated per-test rows against the per-level duration limits (`tests.level_ms` in
timeouts.yml, Get-TestTimeLimits; by default L0 < 400ms, L1 < 2s, L2 < 30s, L3 < 120s). Only passed tests are checked — a failed test's duration is noise — and a row with
no resolved tier is skipped (the tag check already reported it). Test-Automation reports the lines and
fails the run only under -EnforceTimings.
```
