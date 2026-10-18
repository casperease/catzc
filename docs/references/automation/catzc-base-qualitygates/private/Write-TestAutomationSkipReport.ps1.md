---
catzc:
  immutable:
    with_body_sha: ca07ba6801b5
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: write-test-automation-skip-report-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationSkipReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Prints the end-of-run skip report — what was skipped or not run, and why.

### description

Writes a final console section (information stream) distinguishing the two ways a discovered test does
not produce a pass/fail, because they mean different things to the reader:

- Skipped : the test ran discovery and was then skipped from inside the run — a self-skip when its
            tool/cloud is absent (Set-ItResult -Skipped -Because '…'), or an `It -Skip`. Each is
            listed with its reason (the row's SkipReason, resolved by ConvertTo-TestAutomationRowSet
            in the process that ran the test), so "az not installed" is visible rather than a bare
            count.
- Not run : the test was never executed because its tier/category tag fell outside the scope
            this run requested (the -MinLevel/-MaxLevel/-Category filter). These are grouped by
            tier+category with counts and the scope that excluded them — listing all of them would be
            noise, but the breakdown tells the reader exactly what raising -Level would add.

Consumes the run's row set — not a live Pester object — because parallel workers reduce their results
in-process and only the rows survive the process boundary. Silent when nothing was skipped or excluded
(a full run reports nothing here). Best-effort presentation: the caller wraps it so a rendering error
never masks the run outcome.

### parameter Rows

The aggregated per-test rows (ConvertTo-TestAutomationRowSet output, merged across shards).

### parameter MinLevel

The -MinLevel the run was invoked with — names the scope that excluded a test in the "not run" header.

### parameter MaxLevel

The -MaxLevel (-Level) the run was invoked with — names the scope that excluded a test in the "not run"
header.

### parameter Category

The -Category the run was invoked with (Logic/Integrity/Both) — named in the scope when not Both.

## comment:1

Above `if ($skipped.Count -gt 0) {`, written with `#`.

```text
Skipped — actively skipped during the run, each with the reason from Set-ItResult -Because (an `It
-Skip` carries none). Listed individually: a self-skip naming the missing tool is the whole value.
```

## comment:2

Above `if ($notRun.Count -gt 0) {`, written with `#`.

```text
Not run — excluded by this run's tier/category scope, never executed. Grouped by tier+category with
counts so the breakdown shows exactly what a wider -Level/-Category would add, without 90+ lines.
```
