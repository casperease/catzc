/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/types/ContractDirection.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Contracts
    relatives:
      page: docs/references/automation/catzc-base-contracts/types/ContractDirection.cs.md
    adrs:
      - ADR-REPO-CONTRACT#{1,7}
---
*/

namespace Catzc.Base.Contracts;

public enum ContractDirection
{
    DependedOn,
    Provided,
}
