---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
    kind: comment-page
    body_sha: "0607da3d9c86"
    adrs:
      - ADR-AUTO-CONSOLE#7
      - ADR-AUTO-XPLAT#6
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:8

Above `$anchor = if ($Result -eq 'Passed') {`.

```text
Green-rainbow celebrates a pass, red-rainbow marks a fail — the gradient lives in this one end-of-run
verdict and nowhere else
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
"sparingly"). The rule lines take the per-character walk; the
title keeps the anchor's solid base colour (the profile side-grades to Base on the titled line).
```

## comment:9

Above `$detail = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)), matching the title's summary.
```

## comment:10

Above `if ($ReportPath) {`.

```text
The report pointer rides inside the bracket, on its own default-coloured line — the verdict is where a
reader looks last, so it is where "and here is the full report" belongs.
```
