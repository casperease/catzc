# pwsh/Base.Languages/tests/Invoke-BashTest.Tests.ps1

The logic tests of `Invoke-BashTest`. They isolate through the seams
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): a fixture repository root
in `$TestDrive` with a stub vendored runner and its `importer.sh`, a mocked engine probe (`Resolve-EngineExecutable`), and a mocked bash
(`Invoke-Executable`) whose bats writes a canned JUnit report from `tests/assets` into the output folder the command names.
