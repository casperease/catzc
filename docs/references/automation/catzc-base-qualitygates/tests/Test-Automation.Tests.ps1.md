---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Automation.Tests.ps1.md
    kind: test-asset
    body_sha: c317ff9ce39b
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Source & test file conventions' -Tag 'L0', 'integrity',...`.

```text
The source and test file conventions over the real tree, through their quality gate (Test-SourceConventions —
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The gate scans the tree once,
parses each source file once, and lists every offender; this block runs it at its tier and guards it against a
silent no-op.
source-only: it reads the per-function source files, which give the same answer in both run modes.
```

## comment:2

Above `Describe 'Test-Automation (vendored Pester)' -Tag 'L1', 'integrity',...`.

```text
The real-asset test of
[ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) for
Test-Automation's one internal asset: the vendored Pester under
the code root. Pester is already loaded in this worker, so the lazy-load branch is forced by hiding it from
Get-Module, and the re-import is intercepted (re-importing Pester mid-run would unload the running harness);
the run stops at the first step after the import. The path it chose is then checked against the real shipped
module on disk — integrity, and not source-only, so it runs in the source and the build run.
```
