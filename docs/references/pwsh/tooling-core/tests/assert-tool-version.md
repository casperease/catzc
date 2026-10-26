# pwsh/Tooling.Core/tests/Assert-ToolVersion.Tests.ps1

<!-- cspell:ignore lockedtool -->

The L0 tests of `Assert-ToolVersion`.

## Hermetic

Every collaborator is mocked in the module scope, so the assertion binds to the version-check logic, the pipeline lock against the devbox
lever, and never to the shipped `tools.yml` values or the installed toolchain. The fixture tools are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)): faketool carries a
`devbox_version` lever, and lockedtool has none.
