/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/ContractAssetKind.cs.md"
  warning: "Generated Header"
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
