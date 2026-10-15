---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/configs/reports.yml.md
    kind: comment-page
    body_sha: a16108d925b4
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Reports/configs/reports.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `{}`.

```text
reports.yml — where a quality gate writes its report (Write-QualityGateReport,
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). Every key has a sensible default
(Catzc.Base.Reports.ReportsConfig); set a key only to change it. `{subject}` is the gate's subject, e.g. 'spelling'.

  folder: test-{subject}          # the report base folder under the output root (out/ locally)
  report_file: '{subject}.md'     # the report inside a run's stamped folder
  latest_file: latest.txt         # beside the stamped folders: the name of the latest one
  stamp_format: yyyyMMdd-HHmmss   # the stamped folder's name
```
