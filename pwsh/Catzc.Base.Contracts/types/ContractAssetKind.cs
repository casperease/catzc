/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/types/ContractAssetKind.cs
    folder: types
    name: contract-asset-kind
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ContractAssetKind.cs.md](docs/references/pwsh/catzc-base-contracts/types/ContractAssetKind.cs.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
*/

namespace Catzc.Base.Contracts;

// Rests on [ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract).
public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
    Command,
}
