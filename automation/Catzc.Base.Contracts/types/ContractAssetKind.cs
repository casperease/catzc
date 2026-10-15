// The kind of a contract asset, picked by its name alone: Presence is an empty fragment (the real file must exist); Fragment is a file...
// [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
// [comment:1](/docs/references/automation/catzc-base-contracts/types/ContractAssetKind.cs.md#comment1)

namespace Catzc.Base.Contracts;

public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
}
