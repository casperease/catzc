# pwsh/Catzc.Base.Reports/Write-QualityGateReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes a quality gate's report, prints it, and ends the gate: throws once with every issue, or returns the result.

### description

The one implementation of a quality gate's output
([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)), so every gate reports the same
way:

- a run folder `<output root>/<folder>/<stamp>/` holding `<report_file>` — a markdown report naming the gate, its facts, and every issue —
  and `<latest_file>` beside the stamped folders, naming the latest run;
- each issue printed, then the count (or "No `<subject>` issues found."), then the report path;
- with -PassThru, a result object instead of a throw; otherwise, when there are issues, one throw that lists them all (a fail-fast,
  aggregated verdict).

Folder and file names come from configs/reports.yml (Catzc.Base.Reports.ReportsConfig), whose defaults give
`out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md` and `out/test-<subject>/latest.txt`. A gate calls this last, with the issues it
collected; it never writes its own report.

### parameter `Subject`

The gate's subject, kebab-case ('spelling', 'shipped-configs'); names the report folder and file.

### parameter `Title`

The gate's display name ('Test-Spelling'); heads the report and starts the failure message.

### parameter `Issues`

Every issue the gate found, one message each; empty when the repository passes.

### parameter `Facts`

Optional ordered facts about the run (e.g. @{ Terms = 412 }), listed in the report (a list fact as its count) and returned under the
result's `Facts`.

### parameter `OutputFolder`

The report base folder. Defaults to `<output root>/<folder from reports.yml>`.

### parameter `PassThru`

Return the gate's `QualityGateResult` (Subject, IssueCount, Issues, ReportPath and Facts) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Write-QualityGateReport -Subject spelling -Title Test-Spelling -Issues $issues -Facts ([ordered]@{ Files = 812 }) -PassThru:$PassThru
```

## comment:1

Above `if (-not $OutputFolder) {`, written with `#`.

```text
A body fill-in on purpose: every gate forwards its own -OutputFolder here, empty when its caller gave none, and
an explicit empty argument would override a declared default
([ADR-PWSH-PARAM-RESOLUTIONORDER](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).
```
