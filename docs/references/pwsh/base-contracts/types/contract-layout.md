# pwsh/Base.Contracts/types/ContractLayout.cs

What the contracts tree holds at one level: the folders and files directly in a folder, listed through the bounded walker with the
folder-walk config's names pruned, in ordinal order. A folder the layout requires fails when it is missing, so a broken tree is named where
it breaks.

## Constants

- **`CurrentVersion`** — `0.1.0`, the one version folder of every root that holds its current contracts
  ([ADR-REPO-CONTRACT-CURRENTVERSION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-currentversion)).
- **`ProvidedRoot`** — `catzc`, the one root whose assets are provided; every other root is a vendor and its assets are depended-on
  ([ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)).
- **`TypesSurfaceName`** and **`TypesSchemaName`** — a module group's generated types surface and the one schema every group's surface
  validates against. The bootstrap writer runs before this type loads and spells the surface name once in `Get-TypesContractPath`, which a
  test pins to this constant.
