/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/types/ContractDirection.cs
    folder: types
    name: contract-direction
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
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
