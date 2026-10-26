# pwsh/Base.Contracts/types/ContractAsset.cs

One contract asset under `contracts/<root>/<version>/<group>/<path>`
([ADR-REPO-CONTRACT-LAYOUT](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)), with every fact `Get-Contract`
derives from its name alone
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset),
[ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)). A
result type, not a config mirror, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Paths

Every path is in communication form
([ADR-AUTO-PATH-COMMUNICATIONFORM](../../../../drs/automation/path-representation.md#rule-adr-auto-path-communicationform)): relative,
`/`-separated, with no `.`, `..` or empty segment. Construction rejects any other form. The path below the group is its file name, or one
folder that sorts the group's assets and the file name; an asset directly in its version folder has no group.

## Properties

- **`Root`** — the root that carries the contract (e.g. `catzc`).
- **`Version`** — the root's version folder, `<major>.<minor>.<patch>`.
- **`Group`** — the module group folder, empty for an asset directly in the version folder.
- **`Path`** — the asset's path below its group, as named.
- **`Key`** — the asset's path below the version folder: the group and the path.
- **`AssetPath`** — the asset file itself, repository-relative.
- **`Kind`** — a `ContractAssetKind`.
- **`Target`** — the repository-relative file the asset constrains; null for a sample or a types surface, which constrain no file.
- **`Direction`** — a `ContractDirection`.
