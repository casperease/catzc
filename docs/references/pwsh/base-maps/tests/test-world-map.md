# pwsh/Base.Maps/tests/Test-WorldMap.Tests.ps1

The tests of `Test-WorldMap`, which reads the map `Get-WorldMap` returns and reports its stack violations
([DDR-TRACK-ONETECHSTACK](../../../../drs/design/tracks.md#rule-ddr-track-onetechstack)), its undeclared root folders
([DDR-TRACK-ISPLACEDCLUSTER](../../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster)) and the printed labels that name no glossary
term, through `Write-QualityGateReport`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The logic tests mock the map,
the glossary and the labels with widget and gadget fixtures
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The placement itself
is pinned by the `Get-WorldMap` tests.

## The repository

One block runs the gate on the repository's own world map. It reads only the git index and the registries, so its answer cannot differ
between the run modes.
