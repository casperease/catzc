# pwsh/Base.Contracts/types/ContractAssetKind.cs

The kind of a contract asset, picked by its name alone
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)).

## Kinds

- **Presence** is an empty fragment: the real file must exist.
- **Fragment** is a file with no suffix: the real file must exist and contain it.
- **Schema** is `<path>.schema.json`: a JSON Schema that the real file at `<path>`, or the sample payload of the same name beside it,
  validates against.
- **Sample** is `<name>.sample.<ext>`: a payload the owning module's tests produce or parse.
- **Command** is a command contract, `<name>.command.yml`
  ([ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](../../../../drs/repository/command-contracts.md)).
- **Types** is a module group's generated types surface, `ContractLayout.TypesSurfaceName`, checked by the one shared types schema.
