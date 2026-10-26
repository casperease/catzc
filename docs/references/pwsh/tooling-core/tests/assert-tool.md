# pwsh/Tooling.Core/tests/Assert-Tool.Tests.ps1

The L0 tests of `Assert-Tool`.

## The probed branch

A tool with candidate paths is asserted from the probe record, never by its bare name on PATH. The probe is mocked whole, and the fixture
tokens are neutral ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
