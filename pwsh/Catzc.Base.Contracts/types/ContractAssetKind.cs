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
