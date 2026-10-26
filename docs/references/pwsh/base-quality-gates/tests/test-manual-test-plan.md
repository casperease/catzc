# pwsh/Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1

The L0 logic test of `Test-ManualTestPlan`, over a fixture repository in `$TestDrive`. The repository root is mocked, and each test writes
the test files and the plan checks it needs. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
