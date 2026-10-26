/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/ContractAssetKind.cs.md"
  header: "generated"
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
    // A module group's generated types surface, ContractLayout.TypesSurfaceName, checked by the one shared types schema.
    Types,
}
