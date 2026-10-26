# pwsh/Base.QualityGates/tests/Get-TestRunFile.Tests.ps1

The L0 logic test of `Get-TestRunFile`, run over fake Pester test objects in the shape the harness reads: `.Block.BlockContainer.Data` and
`.ScriptBlock.File`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
