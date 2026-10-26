# pwsh/Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1

The L0 logic test of `Get-PythonTestCases`, run over fixture test files in `$TestDrive`. It proves that the helper returns the top-level
test functions of every `test_*.py` file, with the package pytest reports for them. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
