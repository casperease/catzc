# docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md

`automation/Catzc.Base.QualityGates/private/Write-TestAutomationArtifacts.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Persists summary.md + tests.csv beside the per-shard results (Write-TestAutomationReport), points
latest.txt at the run, renders the end-of-run skip report (Write-TestAutomationSkipReport), and writes the
ADR rule-enforcement coverage (Write-TestAutomationRuleCoverage — rule-coverage.md/.csv). Each part is
try/catch-guarded independently: a rendering error is reported as a yellow line and swallowed, so a failing
run still throws for its own reason, not a reporting one.
```

## comment:2

Above `try {`.

```text
Persist the run report (summary.md + tests.csv) beside the per-shard results — written before any
throw, so a failing run still produces it.
```

## comment:3

Above `try {`.

```text
Final section: what was skipped (a self-skip, with its reason) or not run (excluded by this run's
tier/category scope).
```

## comment:4

Above `try {`.

```text
ADR rule-enforcement coverage — report-only, same best-effort discipline. Unions the tagged-test
enforcers (each row's Rules column) with the analyzer-rule enforcers (Get-AnalyzerAdrCoverage) over the
full rule universe. Plain assignment receives the comma-wrapped getter intact; ':'->'#' matches the tags.
```
