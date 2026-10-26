# pwsh/Base.QualityGates/tests/Test-PythonLint.Tests.ps1

The test of `Test-PythonLint`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Logic

The L0 cases mock the scope and ruff at the module boundary and read the collected issues. The report goes to `$TestDrive`. The fixtures use
neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Integrity

The integrity block proves that every Python file the repository holds passes `ruff check`: the Python tests and the agent helpers. It is L2
because it drives the pinned ruff through uv, and it self-skips without uv or the pinned interpreter
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)). It is
source-only, because it reads the repository's own files, which give the same answer in both run modes.
