/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/types/ContractAssetKind.cs
    kind: csharp-type
    module: Catzc.Base.Contracts
    adrs:
      - ADR-REPO-CONTRACT#6
---
*/

// The kind comes from the name alone: Presence is an empty fragment, and the schema suffix is checked before the sample suffix.
// [comment:1](/docs/references/automation/catzc-base-contracts/types/ContractAssetKind.cs.md#comment1)

namespace Catzc.Base.Contracts;

public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
}
