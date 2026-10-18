---
catzc:
  immutable:
    with_body_sha: "63ae6bc9722b"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: write-test-automation-artifacts-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationArtifacts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes a run's report artifacts and the skip report — best-effort, never masking the run outcome.

### description

Persists summary.md + tests.csv beside the per-shard results (Write-TestAutomationReport), points latest.txt at the run, renders the
end-of-run skip report (Write-TestAutomationSkipReport), and writes the ADR rule-enforcement coverage (Write-TestAutomationRuleCoverage —
rule-coverage.md/.csv). Each part is try/catch-guarded independently: a rendering error is reported as a yellow line and swallowed, so a
failing run still throws for its own reason, not a reporting one.

### parameter Rows

The run's aggregated per-test rows.

### parameter RunDirectory

The run's timestamped artifact directory.

### parameter OutputFolder

The report base directory (latest.txt lands here).

### parameter MaxLevel

The run's maximum tier (report metadata).

### parameter Limits

The per-level duration limits (report metadata).

### parameter RunResult

The aggregate verdict ('Passed'/'Failed').

### parameter DurationSeconds

The run's wall-clock duration.

### parameter EnforceTimings

Whether timing violations fail the run (report metadata).

### parameter MinLevel

The run's minimum tier (skip-report scope).

### parameter Category

The run's category (skip-report scope).

### parameter Location

Where the run executed (report metadata) — 'in-place', or the snapshot's provenance.

## comment:1

Above `try {`, written with `#`.

```text
Persist the run report (summary.md + tests.csv) beside the per-shard results — written before any
throw, so a failing run still produces it.
```

## comment:2

Above `try {` (occurrence 2), written with `#`.

```text
Final section: what was skipped (a self-skip, with its reason) or not run (excluded by this run's
tier/category scope).
```

## comment:3

Above `try {` (occurrence 3), written with `#`.

```text
ADR rule-enforcement coverage — report-only, same best-effort discipline. Unions the tagged-test
enforcers (each row's Rules column) with the analyzer-rule enforcers (Get-AnalyzerAdrCoverage) over the
full rule universe. Plain assignment receives the comma-wrapped getter intact; ':'->'#' matches the tags.
```
