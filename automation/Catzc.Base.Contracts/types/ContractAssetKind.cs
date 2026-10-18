/*
---
catzc:
  immutable:
    repo_status: clean
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
      - ADR-REPO-CMDCONTRACT#1
      - ADR-REPO-CONTRACT#6
---
*/

namespace Catzc.Base.Contracts;

// Rests on [ADR-REPO-CMDCONTRACT#1](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract1).
public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
    Command,
}
