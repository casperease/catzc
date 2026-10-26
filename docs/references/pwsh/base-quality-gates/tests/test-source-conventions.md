# pwsh/Base.QualityGates/tests/Test-SourceConventions.Tests.ps1

The L0 logic test of `Test-SourceConventions`, over fixture trees in `$TestDrive`. The repository root is mocked, so each test writes the
source and test files it needs and pins one convention. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)):
widget, gadget and sprocket stand in for the engines, and `ADR-WIDGET-GADGET` for a code the ADR registry declares.

## Fixture helpers

The `useMode` block sets the source-conventions config for the next run: both checks in the given mode, and the engine-set check with one
name phrase and the given exempt globs. The `writeCheckFixtures` block writes the files both source checks find: a `ValidateSet` of engines,
a partial engine set in prose, and a real code in an L0 test's fixture data.

The whole-tree walk follows
[ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded). The fixture
repository stands in for the tracked files, so nothing is pruned.
