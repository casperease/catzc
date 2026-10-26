# pwsh/Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1

The test of `Test-ConfigIdentityHygiene`, in two blocks.

The integrity block reads the real shipped config and derives from the real fixture configs. It is source-only, because those are repository
files, which give the same answer in both run modes.

The logic block mocks the fixture set with a neutral token
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and
pins the gate's uniform shape ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
