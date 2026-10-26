# pwsh/Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1

The tests of `Test-GlobSetIndependence`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over per-layer independence
([FDR-GLOBS-NOOVERLAPWITHINLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nooverlapwithinlayer)).

## Fixtures

The registry, the derived module sets and the tracked-file universe are mocked with neutral fixtures (widget, gadget,
[ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The report goes to
`$TestDrive`.
