# automation/Catzc.Base.Contracts/New-CatsCommandLookup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the command lookup `cats` reads before it starts pwsh, from the command contracts.

### description

Writes the text of `importer-commands.sh`, the sourced bash file Build-RootConfig generates
([ADR-REPO-CMDCONTRACT#5](../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract5)): one tab-separated line per contracted
parameter of `contracts/catzc/0.0.0`, as Get-CommandContract reads it, giving the command, the parameter, its type, whether it is a list,
mandatory or bound from the pipeline (1 or 0), and the contract asset. A command with no parameter has one line with an empty parameter. The
lines sit inside the one variable `_catzc_commands`, ordered by command name.

### parameter `RepositoryRoot`

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[string]`, the whole file, ending in a newline.

### example 1

```powershell
New-CatsCommandLookup
```
