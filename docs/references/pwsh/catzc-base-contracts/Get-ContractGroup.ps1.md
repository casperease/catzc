# pwsh/Base.Contracts/Get-ContractGroup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$found = @(Get-CatzcModule -Name $Module -RepositoryRoot $RepositoryRoot)`, written with `#`.

```text
The group names where the module lives, never the namespace it carries; the contracts config holds the form and
its exceptions (pwsh.base.vs_code for Catzc.Base.VSCode).
```
