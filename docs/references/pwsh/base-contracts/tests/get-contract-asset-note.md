# pwsh/Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1

Tests `Get-ContractAssetNote`. A contract asset's note is the header comment its file can carry without changing what its check compares
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): a YAML asset's
leading `#` lines, a schema's `$comment`, and nothing for every other asset. Fixtures are a widget repository in `TestDrive:`
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). Every fixture written
so far stays named in the manifest, so a second note in the same test still finds the first bound.
