# pwsh/Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1

The tests of `Get-ZshInstallLayout` over a fixture zsh entry. `Get-ToolConfig` is mocked, so the shipped `tools.yml` is never read
([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)) and nothing on disk is touched.
The fixtures carry neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
