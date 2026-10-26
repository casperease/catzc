# pwsh/Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1

The L0 logic test of `Write-TestRunFailures`, over fixture rows and file entries. The console seam (`Write-Message`, `Write-Header`,
`Write-Footer`) is mocked and its lines are collected. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
