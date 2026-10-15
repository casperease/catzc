---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-SourceConventions.Tests.ps1.md
    kind: test-asset
    body_sha: fe66420eb79c
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-SourceConventions' -Tag 'L0', 'logic' {`.

```text
Test-SourceConventions over fixture trees in $TestDrive: the repository root is mocked, so each test writes the
source and test files it needs and pins one convention. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): widget, gadget and sprocket stand
in for the engines, and ADR-WIDGET-GADGET for a code the ADR registry declares.
```

## comment:2

Above `$script:useMode = {`.

```text
Sets the source-conventions config for the next run: both checks in the given mode, the engine-set check
with one name phrase and the given exempt globs.
```

## comment:3

Above `$script:writeCheckFixtures = {`.

```text
Writes the files both source checks find: a ValidateSet of engines, a partial engine set in prose, and a real
code in an L0 test's fixture data.
```
