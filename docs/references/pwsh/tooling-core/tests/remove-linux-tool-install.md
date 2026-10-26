# pwsh/Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1

The L0 tests of `Remove-LinuxToolInstall`, one case per eviction mechanism.

## Fixture

The tool is a neutral fixture
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)),
never a real tool identity.

## Defaults

By default the tool is on PATH, dpkg and uv are absent, and every external probe reports "not found". Each test enables the mechanism it
exercises. With dpkg and uv both absent the command falls through to the stray-file delete, so that test points the command at a real file
under `TestDrive` for the delete to remove.
