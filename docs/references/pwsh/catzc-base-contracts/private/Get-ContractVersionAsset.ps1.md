# pwsh/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every contract asset of one root's version folder, with the files its contract.yml applies_to binds.

### description

A version folder, `contracts/<root>/<version>/`, holds assets directly or in one level of group folders, and optionally its contract.yml
([ADR-REPO-CONTRACT-LAYOUT](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)). A group folder that holds a folder
throws, naming it. A released version also holds its .frozen record, which is not an asset; a .frozen in the current version throws
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)). The files a
fragment or file schema binds are named only by its version's applies_to, as repository-relative globs, and a key that names no asset throws
([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing)). The
tracked files are listed only once an asset's globs need matching.

### parameter `Root`

The contract root folder name, the promiser: `catzc` or a vendor such as `ado`.

### parameter `Version`

The root's version folder name.

### parameter `Folder`

The version folder's absolute path.

### parameter `RepositoryRoot`

The repository root, in which a group that holds a command contract is resolved to its module's root (Get-ContractCommandRoot), once per
group and only when the group holds one.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]`

### example 1

```powershell
Get-ContractVersionAsset -Root widget -Version 0.1.0 -Folder $versionFolder -RepositoryRoot $root
```

## comment:1

Above `$tracked = @{ Paths = $null }`, written with `#`.

```text
The tracked files are listed only once an asset asks for its globs to be matched: nothing is enumerated
speculatively.
```
