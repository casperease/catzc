---
catzc:
  derived:
    path: docs/references/automation/catzc-base-configextensions/tests/Test-ConfigValidators.Tests.ps1.md
    kind: test-asset
    body_sha: b1030c13b2ba
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ConfigValidators' -Tag 'L0', 'logic' {`.

```text
Test-ConfigValidators over a fixture code root in $TestDrive and two in-memory fixture modules whose private
validators the gate lists from their own scope. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `It 'every Assert-*Config validator maps to a configs/*.yml in its module (no...`.

```text
Title deliberately avoids Pester's <var> name-template syntax — under the importer's strict mode an
unmatched <name> token in an It title throws at name-expansion time instead of expanding to empty.
```
