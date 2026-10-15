---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/Write-QualityGateReport.ps1.md
    kind: comment-page
    body_sha: "7aa6a3349b73"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Base.Reports/Write-QualityGateReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one implementation of a quality gate's output
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)), so every gate reports the same way:

  - a run folder <output root>/<folder>/<stamp>/ holding <report_file> — a markdown report naming the gate, its
    facts, and every issue — and <latest_file> beside the stamped folders, naming the latest run;
  - each issue printed, then the count (or "No <subject> issues found."), then the report path;
  - with -PassThru, a result object instead of a throw; otherwise, when there are issues, one throw that lists them
    all (a fail-fast, aggregated verdict).

Folder and file names come from configs/reports.yml (Catzc.Base.Reports.ReportsConfig), whose defaults give
out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md and out/test-<subject>/latest.txt. A gate calls this last, with the
issues it collected; it never writes its own report.
```

## comment:2

Above `if (-not $OutputFolder) {`.

```text
A body fill-in on purpose: every gate forwards its own -OutputFolder here, empty when its caller gave none, and
an explicit empty argument would override a declared default
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:3

Above `if (-not $OutputFolder) {`.

```text
A body fill-in on purpose: every gate forwards its own -OutputFolder here, empty when its caller gave none, and
an explicit empty argument would override a declared default
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```
