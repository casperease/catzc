# pwsh/Base.Contracts/Get-ContractGroup.ps1

The resolver from a module to its contract group, the folder under a contract version that holds the module's contracts. It gives one name
or throws, so no caller guesses a group.

## help

### synopsis

Returns the contract group of a module: the folder under a contract version that holds the module's contracts.

### description

The group names where the module lives, never the namespace it carries: the module's track, a dot, and its folder name in the naming normal
form, e.g. `pwsh.base.contracts`. The contracts config holds the form and its exceptions, which name a group outright for a module whose
folder would not give it (`pwsh.base.vs_code` for Catzc.Base.VSCode). A name that matches no module, or more than one, throws.

### parameter `Module`

The module's full name, e.g. `Catzc.Base.Contracts`.

### parameter `RepositoryRoot`

The repository the module is found in. Default: the current repository.

### outputs

`[string]` The group, e.g. `pwsh.base.contracts`.

### example 1

```powershell
Get-ContractGroup Catzc.Base.Contracts
```

## why the group is not the namespace

The group names where the module lives, never the namespace the module carries, because a namespace can differ from its folder. The
contracts config ([contracts.yml](configs/contracts.yml.md)) holds the form and the exceptions, such as `pwsh.base.vs_code` for
Catzc.Base.VSCode.
