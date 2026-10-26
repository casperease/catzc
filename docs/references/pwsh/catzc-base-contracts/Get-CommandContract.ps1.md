# pwsh/Base.Contracts/Get-CommandContract.ps1

The one reader of command contracts. It turns each contract asset into a typed record, so every caller reads the contract language through
one grammar.

## help

### synopsis

Reads the command contracts, all of them or by command, module, root or version, as typed ContractCommand records.

### description

The one reader of a command contract
([ADR-REPO-CMDCONTRACT-ONEREADER](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-onereader)): every
`<verb_noun>.command.yml` asset Get-Contract lists
([ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract)) is parsed
by the ContractCommand type, the one grammar of the contract language, and comes back with its asset, the command's name, its parameters,
its output and its one-line signature. The selectors take wildcards and narrow the assets the way Get-Contract's do; -Name matches the
command and -Module its group. A contract that does not parse throws, naming the asset: this is the reader, and Test-Contracts is where a
defect is reported as a finding.

### parameter `Name`

The command name(s) in the normal form, wildcards allowed. Default: every command.

### parameter `Module`

The owning module's group folder name(s), wildcards allowed. Default: every group.

### parameter `Root`

The contract root folder name(s), wildcards allowed. Default: every root.

### parameter `Version`

The version folder name(s), wildcards allowed. Default: 0.1.0, the current version.

### parameter `RepositoryRoot`

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[Catzc.Base.Contracts.ContractCommand[]]` in Get-Contract's ordinal order of root, version, group, then path.

### example 1

```powershell
Get-CommandContract
```

### example 2

```powershell
Get-CommandContract -Name get_file_language
```

### example 3

```powershell
(Get-CommandContract -Module catzc.base.languages).Signature
```
