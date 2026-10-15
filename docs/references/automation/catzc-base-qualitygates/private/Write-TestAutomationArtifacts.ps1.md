---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md
    kind: comment-page
    body_sha: "1d7f50ad0898"
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationArtifacts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `try {`.

```text
Persist the run report (summary.md + tests.csv) beside the per-shard results — written before any
throw, so a failing run still produces it.
```

## comment:6

Above `try {`.

```text
Final section: what was skipped (a self-skip, with its reason) or not run (excluded by this run's
tier/category scope).
```

## comment:7

Above `try {`.

```text
ADR rule-enforcement coverage — report-only, same best-effort discipline. Unions the tagged-test
enforcers (each row's Rules column) with the analyzer-rule enforcers (Get-AnalyzerAdrCoverage) over the
full rule universe. Plain assignment receives the comma-wrapped getter intact; ':'->'#' matches the tags.
```
