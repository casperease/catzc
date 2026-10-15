---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ParameterConsistency.Tests.ps1.md
    kind: test-asset
    body_sha: f47a4c63dafd
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ParameterConsistency' -Tag 'L0', 'logic' {`.

```text
Test-ParameterConsistency is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
the logic block mocks the file set, the conflict finder (its own unit), and the exemption config; the integrity block
runs the gate over the real public functions. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Parameter consistency of the public functions' -Tag 'L0',...`.

```text
The real public functions, through the gate.
source-only: it reads the per-function source files, which give the same answer in both run modes.
```
