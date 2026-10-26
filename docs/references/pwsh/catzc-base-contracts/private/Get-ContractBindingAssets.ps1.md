# pwsh/Base.Contracts/private/Get-ContractBindingAssets.ps1

The selector of the assets the repository must honour now. It gives Test-Contracts the current version's assets and the pinned released
ones.

## help

### synopsis

Lists the contract assets the repository must honour now: every asset of the current version folder, and the provided assets of every
released version folder still in the tree.

### description

Contracts are binding ([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests))
on two sets of assets:

- every asset, in both directions, of each unit's current version folder, -Version;
- the provided assets of every other released version folder, any version but the current 0.1.0. Released folders are the pin record: a
  released provided contract is kept while a consumer pins it, and retiring it means deleting its folder
  ([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)).

The depended-on assets of an older released folder are not listed: a depended-on contract follows its outside platform, so only the current
version's expectation binds
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)).

When -Version names a release, the current version 0.1.0 is not listed. A contracts/ tree that does not list throws, as Get-Contract does.

### parameter `Version`

The current version folder of every unit, `<major>.<minor>.<patch>`.

### parameter `RepositoryRoot`

The repository root that holds contracts/.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]` In Get-Contract's ordinal order of unit, version, module, then path.

### example 1

```powershell
Get-ContractBindingAssets -Version 0.1.0 -RepositoryRoot $root
```
