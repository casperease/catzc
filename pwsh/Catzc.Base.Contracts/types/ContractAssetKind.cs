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
