# pwsh/Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1

The tests of the `Test-InternalAssetDependency` gate, over a mocked inventory. The violation and coverage engines have their own tests, so
these pin how the gate turns their records into issues. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
