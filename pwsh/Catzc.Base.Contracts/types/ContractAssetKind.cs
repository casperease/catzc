/*
---
catzc:
  immutable:
    with_body_sha: "2a9bb13afbeb"
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
