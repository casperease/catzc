/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/types/ContractDirection.cs
    folder: types
    name: contract-direction
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ContractDirection.cs.md](docs/references/pwsh/catzc-base-contracts/types/ContractDirection.cs.md)"
    cites:
      - ADR-REPO-CONTRACT-BINDINGINTERFACE
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
---
*/

namespace Catzc.Base.Contracts;

public enum ContractDirection
{
    DependedOn,
    Provided,
}
