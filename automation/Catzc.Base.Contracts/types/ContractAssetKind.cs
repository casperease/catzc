/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/types/ContractAssetKind.cs
    folder: types
    name: contract-asset-kind
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/types/ContractAssetKind.cs.md
    cites:
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
