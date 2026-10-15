# docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md

`automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Renders one end-of-run banner and nothing else: a Write-Header whose rule lines carry a per-character
gradient (green-rainbow on a passing run, red-rainbow on a failing one,
[ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)) while its
titled line
keeps the anchor's solid base colour, a default-coloured counts detail line (the banner rule carries the
signal; the counts are data), and a Write-Footer closing the same gradient. It is the symmetric close to
Write-TestAutomationHeader's cyan opener, printed on every exit path so a run is always visually bracketed.
Every line routes through the shared Write-InformationColored chokepoint, so it stays silent under the Pester
harness ($global:__PesterRunning) with no per-function plumbing.
```

## comment:2

Section `.PARAMETER Result` of the comment-based help.

```text
The aggregate run verdict — the primary argument (Position 0). A ValidateSet, so a value other than 'Passed'
or 'Failed' is rejected at binding (fail-fast,
[ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)). It selects the gradient anchor: green for a
pass, red for a fail.
```

## comment:3

Section `.PARAMETER Summary` of the comment-based help.

```text
The one-line reason shown in the banner title (e.g. '812 passed, 14 skipped in 42.3s', or '3 test(s)
failed') — the caller builds it, so the run's existing pass/failure wording is preserved verbatim.
```

## comment:4

Section `.PARAMETER ReportPath` of the comment-based help.

```text
The run's report directory. Rendered on its own line inside the closing bracket so the "where do I look"
pointer travels with the verdict itself rather than adrift in earlier output. Omitted (empty) prints no line.
```

## comment:5

Above `$anchor = if ($Result -eq 'Passed') {`.

```text
Green-rainbow celebrates a pass, red-rainbow marks a fail — the gradient lives in this one end-of-run
verdict and nowhere else
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
"sparingly"). The rule lines take the per-character walk; the
title keeps the anchor's solid base colour (the profile side-grades to Base on the titled line).
```

## comment:6

Above `$detail = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)), matching the title's summary.
```

## comment:7

Above `if ($ReportPath) {`.

```text
The report pointer rides inside the bracket, on its own default-coloured line — the verdict is where a
reader looks last, so it is where "and here is the full report" belongs.
```
