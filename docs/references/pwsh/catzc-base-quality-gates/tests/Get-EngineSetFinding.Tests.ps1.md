# pwsh/Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1

The tests of `Get-EngineSetFinding` over fixture texts and a fixture engine set. Widget, gadget and sprocket stand in for the model's
engines
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)),
which proves the finder reads the names and their count from its caller, never from a literal of its own.
