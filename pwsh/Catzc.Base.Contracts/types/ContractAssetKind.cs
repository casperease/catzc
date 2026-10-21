/*
---
catzc:
  immutable:
    with_body_sha: c3fc38030d86
  edges:
    docs: "[ContractAssetKind.cs.md](../../../docs/references/pwsh/catzc-base-contracts/types/ContractAssetKind.cs.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
*/

namespace Catzc.Base.Contracts;

// Rests on [ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](/docs/drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract).
public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
    Command,
}
