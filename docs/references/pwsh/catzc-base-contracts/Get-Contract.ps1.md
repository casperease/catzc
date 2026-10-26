# pwsh/Base.Contracts/Get-Contract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the repository's contract assets, with every fact derived from each asset's name and place.

### description

Enumerates `contracts/<root>/<version>/[<group>/]<asset>`
([ADR-REPO-CONTRACT-LAYOUT](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)) and returns one ContractAsset per asset
and bound file. Nothing is registered: the root, version and group come from the folders; the kind from the file name
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)); the direction from the
root, Provided under catzc and DependedOn under a vendor
([ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)); and the
files a fragment, presence asset or file schema binds from its version's contract.yml applies_to, as repository-relative globs
([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing)). Every path
is in communication form
([ADR-AUTO-PATH-COMMUNICATIONFORM](../../../drs/automation/path-representation.md#rule-adr-auto-path-communicationform)).

It lists and derives only: it never reads the real files the assets constrain. Files directly under contracts/ (its README) are not assets,
and neither is a released version folder's .frozen record
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)). A version folder
whose name is not `<major>.<minor>.<patch>`, a folder below a group, and an applies_to entry that names no asset or matches no tracked file
each throw. A missing or empty contracts/ gives an empty result.

### parameter `Root`

The contract roots to list, by folder name; wildcards allowed. Default: every root.

### parameter `Version`

The versions to list, by folder name; wildcards allowed. Default: 0.1.0, the current version.

### parameter `Group`

The groups to list, by folder name; wildcards allowed. Default: every group, and the assets directly in the version folder.

### parameter `Path`

Keeps the assets whose path in their group, or whose target, matches; wildcards allowed. Default: every asset.

### parameter `RepositoryRoot`

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]` in ordinal order of root, version, group, then path.

### example 1

```powershell
Get-Contract
```

### example 2

```powershell
Get-Contract -Root catzc -Version *
```

### example 3

```powershell
Get-Contract -Path .github/workflows/*
```
