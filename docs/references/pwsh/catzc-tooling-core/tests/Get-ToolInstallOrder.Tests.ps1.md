# pwsh/Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1

The L0 tests of `Get-ToolInstallOrder`, in two parts: the sorting algorithm over a controlled graph, and the invariants of the shipped
`tools.yml`.

## The algorithm

The sort is isolated from the shipped `tools.yml` by mocking the config seam to a controlled graph. That verifies the algorithm,
dependencies before dependents, a diamond, an independent root and cycle detection, and never the production tool set
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams),
[ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)). The
names `base`, `mid1`, `mid2`, `top` and `lone` are fixture identities
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)), so
nothing here binds to a real tool name.

## The shipped set

The second part binds to the shipped config as a set and asserts invariants that hold for every tool, never a specific tool name or a
hardcoded pairing
([ADR-AUTO-TEST-GENERICTEMPLATETESTS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-generictemplatetests)). The file is
read raw, wherever its owning module (Catzc.Base.Execution) keeps it, so the set compared against is the YAML itself, not the typed model
`Get-ToolInstallOrder` reads.
