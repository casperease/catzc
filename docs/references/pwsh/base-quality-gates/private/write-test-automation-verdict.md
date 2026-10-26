# pwsh/Base.QualityGates/private/Write-TestAutomationVerdict.ps1

Writes the closing verdict banner for a completed Test-Automation run, a rainbow-framed bracket that mirrors the scope header the run opened
with.

## help

### synopsis

Writes the closing verdict banner for a completed Test-Automation run — the rainbow-framed bracket that mirrors the scope header the run
opens with.

### description

Renders one end-of-run banner and nothing else: a Write-Header whose rule lines carry a per-character gradient (green-rainbow on a passing
run, red-rainbow on a failing one,
[ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)) while its titled
line keeps the anchor's solid base colour, a default-coloured counts detail line (the banner rule carries the signal; the counts are data),
and a Write-Footer closing the same gradient. It is the symmetric close to Write-TestAutomationHeader's cyan opener, printed on every exit
path so a run is always visually bracketed. Every line routes through the shared Write-InformationColored chokepoint, so it stays silent
under the Pester harness ($global:__PesterRunning) with no per-function plumbing.

### parameter `Result`

The aggregate run verdict — the primary argument (Position 0). A ValidateSet, so a value other than 'Passed' or 'Failed' is rejected at
binding (fail-fast, [ADR-AUTO-FAILFAST](../../../../drs/automation/fail-fast-with-asserts.md)). It selects the gradient anchor: green for a
pass, red for a fail.

### parameter `Summary`

The one-line reason shown in the banner title (e.g. '812 passed, 14 skipped in 42.3s', or '3 test(s) failed') — the caller builds it, so the
run's existing pass/failure wording is preserved verbatim.

### parameter `PassedCount`

Passed-test count, rendered on the default-coloured detail line under the title.

### parameter `FailedCount`

Failed-test count, rendered on the detail line.

### parameter `SkippedCount`

Skipped-test count, rendered on the detail line.

### parameter `DurationSeconds`

Wall-clock duration, rendered on the detail line.

### parameter `ReportPath`

The run's report directory. Rendered on its own line inside the closing bracket so the "where do I look" pointer travels with the verdict
itself rather than adrift in earlier output. Omitted (empty) prints no line.

## Colour

A green rainbow marks a pass and a red rainbow marks a fail. The gradient lives in this one end-of-run verdict and nowhere else, which keeps
colour sparing ([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)).
The rule lines take the per-character walk, and the title keeps the anchor's solid base colour.

## Duration

The detail line formats the duration with the invariant culture, so it reads the same on any devbox culture and matches the title's summary
([ADR-AUTO-XPLAT-INVARIANTCULTURE](../../../../drs/automation/cross-platform.md#rule-adr-auto-xplat-invariantculture)).

## Report pointer

The report pointer rides inside the bracket, on its own default-coloured line. The verdict is where a reader looks last, so it is where the
full report belongs.
