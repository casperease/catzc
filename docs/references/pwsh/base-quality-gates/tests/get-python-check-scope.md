# pwsh/Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1

The L0 logic test of `Get-PythonCheckScope`, with the test folders and the git index mocked. The Python checks read the test folders and
every tracked `.py` file outside the Python root, and the test proves that scope. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
