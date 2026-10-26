# pwsh/Base.Languages/tests/Invoke-PythonTest.Tests.ps1

The logic tests of `Invoke-PythonTest`. They isolate through the seams
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): a fixture repository root
in `$TestDrive`, a mocked tool probe (`Resolve-ToolExecutable`) that finds a managed uv at a fixture path with a space in it, and a mocked
uv (`Invoke-Executable`) whose pytest writes a canned JUnit report from `tests/assets` to the path the command names.
