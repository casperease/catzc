# pwsh/Base.Contracts/private/Get-CommandContractMap.ps1

The lookup table of command contracts by command name. It keeps the loop over Get-CommandContract in one place for the accosted reader, the
runner and the fragment renderer.

## help

### synopsis

Reads the command contracts once into a table keyed by the contracted command's name in the normal form.

### description

The one place the accosted reader, the runner and the fragment renderer build the contracts-by-name table from `Get-CommandContract`, so no
caller keeps its own copy of the loop.

### parameter `RepositoryRoot`

The repository whose command contracts are read. Default: the repository root.

### outputs

`[hashtable]` The command contracts, each under its name.
