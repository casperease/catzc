# pwsh/Base.Contracts/private/Get-ContractRootAsset.ps1

The lister of one contract root's assets across the selected version folders. It rejects anything in the root that is not a version folder.

## help

### synopsis

Lists every contract asset of one root, across the version folders the version patterns select.

### description

A root folder, `contracts/<root>/`, holds only version folders named `<major>.<minor>.<patch>`
([ADR-REPO-CONTRACT-LAYOUT](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)); a file beside them, or a folder
with any other name, throws, naming it. Each selected version folder is listed by Get-ContractVersionAsset.

### parameter `Root`

The root folder name, the promiser: `catzc`, or a vendor root once a vendor ships a shape we copy verbatim.

### parameter `Folder`

The root folder's absolute path.

### parameter `Version`

The version folder names to list, as wildcard patterns.

### parameter `RepositoryRoot`

The repository root, passed on to Get-ContractVersionAsset.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]`

### example 1

```powershell
Get-ContractRootAsset -Root catzc -Folder $rootFolder -Version '0.1.0' -RepositoryRoot $root
```
