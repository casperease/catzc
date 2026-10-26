# pwsh/Tooling.Python/tests/Install-PipTool.Tests.ps1

The tests of the private `Install-PipTool`. They run against a neutral library-shaped fixture tool, `widget`, with a `pip_package` and no
launcher of its own, so the case covers a package that puts nothing on PATH without naming a real one
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
