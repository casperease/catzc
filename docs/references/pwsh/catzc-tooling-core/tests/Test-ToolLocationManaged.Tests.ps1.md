# pwsh/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Prefix logic keyed on Windows paths; the Unix branches are analogous and not exercised here.
Set-ItResult is legal only in a per-test scope, so the non-Windows skip must run in BeforeEach, not
BeforeAll — calling it in BeforeAll throws and fails the whole Describe off-Windows (it silently passed
on Windows only because the guard was false there).
```

## comment:2

Above `$config = Get-ToolConfig -Tool 'java'`, written with `#`.

```text
winget installs Microsoft.OpenJDK user-scope under %LOCALAPPDATA%\Programs, NOT under
\Microsoft\WinGet\Packages — so this root must count or a winget-managed JDK reads as foreign.
```

## comment:3

Above `$config = Get-ToolConfig -Tool 'uv'`, written with `#`.

```text
Install-Uv treats a uv on PATH outside the winget root (its standalone/user bin) as a managed,
self-updating install, so the janitor must agree rather than flag it foreign.
```

## comment:4

Above `Mock Get-ScriptInstallDir { 'C:\Users\me\AppData\Local\Gadget' }`, written with `#`.

```text
Neutral fixture
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
