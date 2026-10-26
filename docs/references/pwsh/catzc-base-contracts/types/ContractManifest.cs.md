# pwsh/Base.Contracts/types/ContractManifest.cs

A version folder's `contract.yml`, at `contracts/<root>/<version>/contract.yml`: the per-asset exceptions to the default addressing, where
an asset constrains the files its globs name instead of the one file at its own path
([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing)). It
mirrors the YAML mapping, so the property is snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

- **`applies_to`** — a map of an asset's path in the version folder (`<file>`, `<group>/<file>` or `<group>/<folder>/<file>`) to a non-empty
  list of repository-relative, `/`-separated globs. The asset constrains every tracked file the globs match.

Construction validates the file and collects every violation into one `ArgumentException`; an unknown key throws. That every named asset
exists and binds files is the enumeration's check, since only it knows the assets.
