# pwsh/Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1

The tests of `Test-GlobSetIndependence`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over per-layer independence
([FDR-CD-GLOBS-NOOVERLAPWITHINLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nooverlapwithinlayer)).

## Fixtures

The registry, the derived module sets and the tracked-file universe are mocked with neutral fixtures (widget, gadget,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
report goes to `$TestDrive`.
