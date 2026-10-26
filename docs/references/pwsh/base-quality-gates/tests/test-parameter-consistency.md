# pwsh/Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1

The test of `Test-ParameterConsistency`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

The logic block mocks the file set, the conflict finder (its own unit) and the exemption config. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

The integrity block runs the gate over the real public functions. It is source-only, because it reads the per-function source files, which
give the same answer in both run modes.
