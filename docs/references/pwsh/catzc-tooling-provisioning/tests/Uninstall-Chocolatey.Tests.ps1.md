# pwsh/Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1

The tests of `Uninstall-Chocolatey`, hermetic: every boundary outside the repository is mocked, namely the admin check, the directory
delete, the persistent variable (`Set-PermanentEnvironmentVariable`) and the persistent PATH (`Get-EnvironmentPath` and
`Set-EnvironmentPath`). The seams' real registry round trips are their own L3 system tests
([ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)).
