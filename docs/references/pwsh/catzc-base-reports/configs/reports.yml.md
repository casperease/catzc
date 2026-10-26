# pwsh/Base.Reports/configs/reports.yml

Where a quality gate writes its report (`Write-QualityGateReport`,
[ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Keys

Every key has a sensible default (`Catzc.Base.Reports.ReportsConfig`); a key is set only to change it. `{subject}` is the gate's subject, for
example `spelling`.

```text
folder: test-{subject}          # the report base folder under the output root (out/ locally)
report_file: '{subject}.md'     # the report inside a run's stamped folder
latest_file: latest.txt         # beside the stamped folders: the name of the latest one
stamp_format: yyyyMMdd-HHmmss   # the stamped folder's name
```
