# pwsh/Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1

The L0 logic test of `Invoke-PythonWorkspaceTool`, with uv mocked through `Resolve-ToolExecutable` and `Invoke-Executable`, over a fixture
workspace in `$TestDrive`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
