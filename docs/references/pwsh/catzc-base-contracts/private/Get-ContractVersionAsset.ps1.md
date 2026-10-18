# automation/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every contract asset of one unit version folder, with its contract.yml overrides applied.

### description

A version folder, `contracts/<unit>/<version>/`, holds one folder per owning module and, optionally, its contract.yml
([ADR-REPO-CONTRACT#2](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract2),
[ADR-REPO-CONTRACT#7](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract7)). Every file under a module folder is an asset,
at any depth. A released version folder also holds its .frozen record, the hash of each of its files that Publish-ContractRelease writes
when it freezes the draft ([ADR-REPO-CONTRACT#5](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract5)); it is not an asset.
Any other file at the version level, and a .frozen in the draft 0.0.0, has no owning module, and a contract.yml entry that names no asset
overrides nothing; both throw, naming the file or the entry. Each asset's target sits under its module's target root, which
ContractsConfig.ResolveTargetRoot picks from -TargetRoot
([ADR-REPO-CONTRACT#2](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract2)). Assets come in ordinal order of module, then
path.

### parameter `Unit`

The deployable-unit folder name.

### parameter `Version`

The unit's version folder name.

### parameter `Folder`

The version folder's absolute path.

### parameter `TargetRoot`

The target roots, module name to repository-relative folder. A module it does not name takes the repository root.

### parameter `RepositoryRoot`

The repository root, in which a module that holds a command contract is resolved to its root (Get-ContractCommandRoot), once per module and
only when the module folder holds one.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]`

### example 1

```powershell
Get-ContractVersionAsset -Unit widget -Version 0.0.0 -Folder $versionFolder -TargetRoot @{} -RepositoryRoot $root
```

## comment:1

Above `$files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
asset of the version is listed, so no name is pruned and no depth drops one.
```
