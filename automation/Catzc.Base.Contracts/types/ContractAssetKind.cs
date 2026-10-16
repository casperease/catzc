/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/types/ContractAssetKind.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.Contracts
    relatives:
      page: docs/references/automation/catzc-base-contracts/types/ContractAssetKind.cs.md
    adrs:
      - ADR-REPO-CONTRACT#6
---
*/

namespace Catzc.Base.Contracts;

public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
}
