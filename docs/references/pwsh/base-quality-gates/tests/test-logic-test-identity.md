# pwsh/Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1

The test of `Test-LogicTestIdentity`, in two blocks.

The integrity block binds the real shipped config, from which the live-identity set is derived, so it also names live identities such as
`apex` as fixture data. The integrity tag is correct
([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)), and it is also what exempts
that block from the gate's own self-scan. The block is source-only, because it scans the repository's test files, which give the same answer
in both run modes.

The logic block mocks the live set with neutral tokens
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and
pins the gate's uniform shape ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
