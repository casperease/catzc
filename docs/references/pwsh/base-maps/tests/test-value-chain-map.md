# pwsh/Base.Maps/tests/Test-ValueChainMap.Tests.ps1

The tests of `Test-ValueChainMap`, which reads the map `Get-ValueChainMap` returns and reports axes that are not the registry's closed sets
([ADR-REPO-VALUECHAIN-STACK](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-stack),
[ADR-REPO-VALUECHAIN-CONCERN][r1]), ADRs it cannot place, and `value_chain_`
labels that name no glossary term ([ADR-REPO-VALUECHAIN-MAP][r2]), through
`Write-QualityGateReport` ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The
logic tests mock the map, the glossary and the labels with widget and gadget fixtures
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The clean map's axes
are the closed sets `DrsConfig` declares, read from the type.

## The repository

One block runs the gate on the registry's own map. It reads only `drs.yml` and `maps.yml`, so its answer cannot differ between the run
modes.

[r1]: ../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-concern
[r2]: ../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map
