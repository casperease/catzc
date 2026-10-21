/*
---
catzc:
  immutable:
    with_body_sha: "2f6928dcd649"
  edges:
    docs: "[ContractDirection.cs.md](../../../docs/references/pwsh/catzc-base-contracts/types/ContractDirection.cs.md)"
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
