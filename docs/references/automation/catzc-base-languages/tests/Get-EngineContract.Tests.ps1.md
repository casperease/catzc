---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md
    kind: test-asset
    body_sha: "9a6fa0fc8652"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-EngineContract' -Tag 'L0', 'logic' {`.

```text
Get-EngineContract with the engines' executables mocked: the start arguments come from the execution engine model and
load the run's entry — directly in pwsh, through importer.sh and CATZC_IMPORTER in the POSIX engines. Neutral fixture paths
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
