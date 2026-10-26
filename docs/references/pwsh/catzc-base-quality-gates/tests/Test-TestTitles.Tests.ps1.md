# pwsh/Base.QualityGates/tests/Test-TestTitles.Tests.ps1

The L0 logic test of `Test-TestTitles`, over fixture test files in `$TestDrive`, with the repository root mocked. The fixture titles are
built from string pieces, so this file's own titles never carry the very token the gate bans. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
