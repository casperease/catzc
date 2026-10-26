# pwsh/Base.Languages/tests/New-GoWorkspace.Tests.ps1

The logic tests of `New-GoWorkspace`. They isolate through the seams
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): a fixture config, a fixture
`tools.yml` pin and a fixture repository root in `$TestDrive`.
