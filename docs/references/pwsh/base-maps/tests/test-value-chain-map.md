# pwsh/Base.Maps/tests/Test-ValueChainMap.Tests.ps1

The tests of `Test-ValueChainMap`, which reads the map `Get-ValueChainMap` returns and reports axes that are not the registry's closed sets
([DDR-TRACK-VALUECHAINSTACK](../../../../drs/design/tracks.md#rule-ddr-track-valuechainstack),
[DDR-TRACK-VALUECHAINCONCERN](../../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)), ADRs it cannot place, and `value_chain_`
labels that name no glossary term ([DDR-TRACK-VALUECHAINMAP](../../../../drs/design/tracks.md#rule-ddr-track-valuechainmap)), through
`Write-QualityGateReport` ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The
logic tests mock the map, the glossary and the labels with widget and gadget fixtures
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The clean map's axes
are the closed sets `DrsConfig` declares, read from the type.

## The repository

One block runs the gate on the registry's own map. It reads only `drs.yml` and `maps.yml`, so its answer cannot differ between the run
modes.
