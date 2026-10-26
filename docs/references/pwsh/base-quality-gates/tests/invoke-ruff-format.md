# pwsh/Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1

The L0 logic test of the ruff engine `Invoke-RuffFormat`, with its seams mocked
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): ruff run from the Python
workspace through `Invoke-PythonWorkspaceTool`, and the `python.yml` root. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
