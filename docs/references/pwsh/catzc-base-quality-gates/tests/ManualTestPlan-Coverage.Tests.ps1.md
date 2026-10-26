# pwsh/Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1

The integrity test that keeps the manual test plan's category files (`docs/how-to/pwsh/manual-test-plan/`) in step with the tests, through
its quality gate `Test-ManualTestPlan`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The gate derives the integrity
blocks by parsing the test files, never by booting Pester discovery
([ADR-AUTO-TEST-INTEGRITYREADSFILES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-integrityreadsfiles)).

The test is self-referential: its own `Describe` is integrity-tagged, so the plan lists it too. It is source-only, because it reads the
repository's test files and the plan document, which give the same answer in both run modes.
