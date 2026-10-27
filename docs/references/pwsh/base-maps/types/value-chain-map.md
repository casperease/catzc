# pwsh/Base.Maps/types/ValueChainMap.cs

The value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, every cell of that grid, and the ADRs each
cell holds ([ADR-REPO-VALUECHAIN-MAP](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map)).

## Where an ADR sits

An ADR sits on its ADR domain's row (`DrsRuleSet.Stack`,
[ADR-REPO-VALUECHAIN-STACK][r1]) in the column of each of its value-chain
concerns (`DrsRuleSet.Concerns`, an override or its ADR domain's default,
[ADR-REPO-VALUECHAIN-CONCERN][r2]). So it sits in one or more cells of one
row.

## Build

`Build` takes the axes and the ADRs (`Get-ValueChainMap` passes `DrsConfig.Stacks`, `DrsConfig.Concerns` and the `drs.yml` rule-sets). An
empty or repeated axis name, an item that is not a `DrsRuleSet`, or a repeated ADR code throws.

The `DrsConfig` load rejects an unknown row or value-chain concern, so on the registry every ADR sits in a cell. The map still records what
it cannot place instead of dropping it: `Strays` names each row or value-chain concern an ADR declares that the axes lack, and `Unplaced`
each ADR that sits in no cell. `Test-ValueChainMap` reports both.

## Order

The order is deterministic: rows and columns as given, cells row by row, the ADRs of a cell in the given order. `ToJson` is its data form
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).

[r1]: ../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-stack
[r2]: ../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-concern
