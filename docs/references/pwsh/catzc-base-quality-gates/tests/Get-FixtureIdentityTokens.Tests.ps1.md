# pwsh/Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1

The tests of `Get-FixtureIdentityTokens`, at L1, over a fixture `pwsh/` tree in `$TestDrive` with `Get-RepositoryRoot` mocked. It reads
files and constructs the registered types: the fixture `azure.yml` and `customer.yml` are built as their registered C# config types, so the
YAML is a valid instance of each. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
quality gate `Test-ConfigIdentityHygiene` checks that they stay disjoint from the live identities.
