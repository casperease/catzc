# pwsh/Base.Reports/configs/reports.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `{}`, written with `#`.

```text
reports.yml — where a quality gate writes its report (Write-QualityGateReport,
[ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Every key has a sensible default
(Catzc.Base.Reports.ReportsConfig); set a key only to change it. `{subject}` is the gate's subject, e.g. 'spelling'.

  folder: test-{subject}          # the report base folder under the output root (out/ locally)
  report_file: '{subject}.md'     # the report inside a run's stamped folder
  latest_file: latest.txt         # beside the stamped folders: the name of the latest one
  stamp_format: yyyyMMdd-HHmmss   # the stamped folder's name
```
