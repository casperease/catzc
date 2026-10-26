# pwsh/Base.QualityGates/tests/Test-Change.Tests.ps1

The L0 logic test of the `Test-Change` wiring. The two halves of the plan, `Get-ChangeTestFile` and `Get-ChangeCheckPlan`, are their own
units and are mocked here. `Invoke-TestFile` is the mocked test-run boundary. The gates are fixture functions, so the real `Get-Command`
lookup and the `[string[]]` `-Path` test decide how each is called. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The fixture gates

There are three fixture gates: one that takes the changed files, one that only runs whole, and one that throws. Each names every path it was
given, so its issue shows what `Test-Change` passed.
