# pwsh/Catzc.Base.Contracts/New-CatsCommandLookup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the command lookup `cats` reads before it starts pwsh, from the command contracts.

### description

Writes the text of `pwsh/.internal/assets/importer-commands.sh`, the sourced bash file Build-RootConfig generates
([ADR-REPO-CMDCONTRACT-ONEREADER](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-onereader)): one tab-separated line
per contracted parameter of `contracts/catzc/0.0.0`, as Get-CommandContract reads it, with thirteen columns in this order: (1) the command
and (2) the parameter in the normal form, (3) the parameter's type, (4) list, (5) mandatory and (6) pipeline, each 1 or 0, (7) the contract
asset, (8) the parameter's sets, comma-separated and empty for every set, (9) the command's default set, empty for none, (10) the command
and (11) the parameter in kebab case, as cats takes them, then (12) the command and (13) the parameter in PowerShell's case, as pwsh binds
them. A command with no parameter has one line with the parameter columns empty and 0. The lines sit inside the one variable
`_catzc_commands`, ordered by command name.

### parameter `RepositoryRoot`

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[string]`, the whole file, ending in a newline.

### example 1

```powershell
New-CatsCommandLookup
```

## comment:1

Above `$languages = Get-Config -Config languages`, written with `#`.

```text
Every name is keyed by its normal form and carries its two renderings: kebab, as cats takes it, and PowerShell's,
as pwsh binds it.
```
