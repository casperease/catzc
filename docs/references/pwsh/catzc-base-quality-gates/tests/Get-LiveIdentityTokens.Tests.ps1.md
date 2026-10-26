# pwsh/Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1

The tests of `Get-LiveIdentityTokens`. Fixture configs come through the `Get-Config` seam, so the derivation must reflect exactly what the
config declares, never a hand-kept list. The live identities here are the fixture identities the mocked config declares. The derivation
logic is identical against the real config
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). Two
declaring modules (`identity-tokens.yml`) each name only the configs they own.
