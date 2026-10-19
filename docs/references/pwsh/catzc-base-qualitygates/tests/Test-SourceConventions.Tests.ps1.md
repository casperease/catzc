# automation/pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-SourceConventions' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-SourceConventions over fixture trees in $TestDrive: the repository root is mocked, so each test writes the
source and test files it needs and pins one convention. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): widget, gadget and sprocket stand
in for the engines, and ADR-WIDGET-GADGET for a code the ADR registry declares.
```

## comment:2

Above `$script:useMode = {`, written with `#`.

```text
Sets the source-conventions config for the next run: both checks in the given mode, the engine-set check
with one name phrase and the given exempt globs.
```

## comment:3

Above `$script:writeCheckFixtures = {`, written with `#`.

```text
Writes the files both source checks find: a ValidateSet of engines, a partial engine set in prose, and a real
code in an L0 test's fixture data.
```

## comment:4

Above `foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A whole-tree walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/adr/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the
fixture repository stands in for the tracked files, so nothing is pruned.
```
