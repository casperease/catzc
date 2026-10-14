// The kind of a contract asset, picked by its name alone
// ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): Presence is an empty fragment (the
// real file must exist); Fragment is a file with no suffix (the real file must exist and contain it); Schema is
// `<path>.schema.json` (a JSON Schema the real file at `<path>`, or the sample payload of the same name beside it, validates
// against); Sample is `<name>.sample.<ext>` (a payload the owning module's tests produce or parse).

namespace Catzc.Base.Contracts;

public enum ContractAssetKind
{
    Presence,
    Fragment,
    Schema,
    Sample,
}
