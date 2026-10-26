# pwsh/Base.Languages/tests/Invoke-GoTest.Tests.ps1

The logic tests of `Invoke-GoTest`. They isolate through the seams
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): a fixture repository root
in `$TestDrive`, a mocked tool probe (`Resolve-ToolExecutable`) that finds a managed go at a fixture path with a space in it, and a mocked
go (`Invoke-Executable`) that answers with canned `go test -json` streams from `tests/assets`.
