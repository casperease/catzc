# pwsh/Base.Maps/tests/Get-ValueChainMap.Tests.ps1

The tests of `Get-ValueChainMap`, which builds the value-chain map from the registry's closed sets and its ADRs
([DDR-TRACK-VALUECHAINMAP](../../../../drs/design/tracks.md#rule-ddr-track-valuechainmap)). The logic tests mock the ADRs with widget and
gadget fixtures
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
axes are the closed sets `DrsConfig` declares, read from the type, never spelled out in the test.

## The real registry

One block runs against the registry's own value-chain map. It reads only `drs.yml`, so its answer cannot differ between the run modes.
