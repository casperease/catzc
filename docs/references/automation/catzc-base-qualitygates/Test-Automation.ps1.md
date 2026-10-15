---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
    kind: comment-page
    body_sha: "01561ab017be"
    adrs:
      - ADR-AUTO-TEST#30
      - ADR-AUTO-TEST#37
---

# automation/Catzc.Base.QualityGates/Test-Automation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:17

Above `if ($Suite) {`.

```text
-Suite: run a test suite — the named globset's declared verify scope resolves to the module list and tier
(Resolve-TestSuite, [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)).
```

## comment:18

Above `Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation'...`.

```text
The harness itself — discovery, tag checks, sharding, workers, rows, reports — is the core both runs
share (Invoke-TestRun,
[ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)). The source run loads each
worker through the
repository importer, the core's default.
```
