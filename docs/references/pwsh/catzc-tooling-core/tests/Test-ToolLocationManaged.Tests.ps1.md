# pwsh/Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1

The L0 tests of `Test-ToolLocationManaged`.

## Windows only

The prefix logic is keyed on Windows paths; the Unix branches are analogous and not exercised here. `Set-ItResult` is legal only in a
per-test scope, so the non-Windows skip runs in `BeforeEach`, not `BeforeAll`: calling it in `BeforeAll` throws and fails the whole
`Describe` off-Windows.

## Roots

- winget installs Microsoft.OpenJDK user-scope under `%LOCALAPPDATA%\Programs`, not under `\Microsoft\WinGet\Packages`, so that root must
  count or a winget-managed JDK reads as foreign.
- `Install-Uv` treats a uv on PATH outside the winget root, in its standalone user bin, as a managed, self-updating install, so the janitor
  must agree rather than flag it foreign.

The `Get-ScriptInstallDir` mock uses a neutral fixture
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
