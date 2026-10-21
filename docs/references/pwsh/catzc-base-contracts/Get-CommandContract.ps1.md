# pwsh/Catzc.Base.Contracts/Get-CommandContract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the command contracts, all of them or by command, module, unit or version, as typed ContractCommand records.

### description

The one reader of a command contract
([ADR-REPO-CMDCONTRACT-ONEREADER](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-onereader)): every
`<Verb-Noun>.command.yml` asset Get-Contract lists
([ADR-REPO-CMDCONTRACT-COMMANDCONTRACT](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-commandcontract)) is parsed
by the ContractCommand type, the one grammar of the contract language, and comes back with its asset, the command's name, its parameters,
its output and its one-line signature. The selectors take wildcards and narrow the assets the way Get-Contract's do; -Name matches the
command. A contract that does not parse throws, naming the asset: this is the reader, and Test-Contracts is where a defect is reported as a
finding.

### parameter `Name`

The command name(s), Verb-Noun, wildcards allowed. Default: every command.

### parameter `Module`

The owning module name(s), wildcards allowed. Default: every module.

### parameter `Unit`

The deployable-unit folder name(s), wildcards allowed. Default: every unit.

### parameter `Version`

The version folder name(s), wildcards allowed. Default: 0.0.0, each unit's draft.

### parameter `RepositoryRoot`

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[Catzc.Base.Contracts.ContractCommand[]]` in Get-Contract's ordinal order of unit, version, module, then path.

### example 1

```powershell
Get-CommandContract
```

### example 2

```powershell
Get-CommandContract -Name Get-FileLanguage
```

### example 3

```powershell
(Get-CommandContract -Module Catzc.Base.Languages).Signature
```
