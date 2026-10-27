# pwsh/Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1

The L0 logic test of `Get-TestTagViolations`, run over a fake discovery.

## Fixtures

The rule-id set is a fixture, so the validation is hermetic and never reads the shipped ADR tree. Mocking the whole boundary function
`Get-DrsRuleIds` is the seam ([ADR-AUTO-TEST](../../../../drs/automation/test-automation.md)).

The fake discovery is plain data. The test builds it in Pester scope and passes it into `InModuleScope` through `-Parameters`, because a
function defined in Pester scope is not visible in the module's session state.
