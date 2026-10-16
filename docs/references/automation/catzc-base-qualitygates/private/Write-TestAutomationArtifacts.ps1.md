---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "63ae6bc9722b"
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationArtifacts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
