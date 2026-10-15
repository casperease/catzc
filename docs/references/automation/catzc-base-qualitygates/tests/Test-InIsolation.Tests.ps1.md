---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-InIsolation.Tests.ps1.md
    kind: test-asset
    body_sha: "8f1b33c55533"
    adrs:
      - ADR-AUTO-ASSETDEP#3
---

# automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-InIsolation (vendored Pester)' -Tag 'L1', 'integrity',...`.

```text
The real-asset test of
[ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) for
Test-InIsolation's lazy Pester load: the vendored Pester under
the code root. Pester is already loaded in this worker, so the lazy-load branch is forced by hiding it from
Get-Module and the re-import is intercepted (re-importing Pester mid-run would unload the running harness); the
run stops at the first step after the import. The chosen path is then checked against the real shipped module
on disk — integrity, and not source-only, so it runs in the source and the build run.
```
