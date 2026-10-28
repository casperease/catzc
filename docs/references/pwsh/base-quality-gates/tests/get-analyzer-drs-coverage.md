# pwsh/Base.QualityGates/tests/Get-AnalyzerDrsCoverage.Tests.ps1

The tests of `Get-AnalyzerDrsCoverage`, the analyzer-to-rule map. The integrity case is source-only: it cross-checks the map against the
repository's DRS tree and `.scriptanalyzer` rule files, which gives the same answer in both run modes. The check is the quality gate
`Test-AnalyzerDrsMap` ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
