---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/tests/Config-Conventions.Tests.ps1.md
    kind: test-asset
    body_sha: dff65e2d82c2
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Config conventions' -Tag 'L0', 'integrity' {`.

```text
Poka-yoke backstop for the config registry (see ADR module-config-loading): every shipped config has a
registered C# config type and loads through it (Test-ShippedConfigs).
```

## comment:2

Above `$result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive...`.

```text
The quality gate (Test-ShippedConfigs, in Catzc.Base.QualityGates: Catzc.Base.Reports depends on
Catzc.Base.Config, so the gate cannot live here) lists every issue over the loaded code root
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
