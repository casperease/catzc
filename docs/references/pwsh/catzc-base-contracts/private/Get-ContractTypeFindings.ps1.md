# pwsh/Base.Contracts/private/Get-ContractTypeFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks the types surfaces of a contracts version against the command contracts and the module groups.

### description

Every catzc type a command contract names in its parameters or output, in the normal form, must be listed in some group's types surface; and
each group holding a types surface must be the group Get-ContractGroup names for the module its types' namespace names, since the bootstrap
writer derives the group without reading contracts.yml. A version with no folder under the provided root has no findings.

### parameter `Version`

The contracts version under the provided root.

### parameter `RepositoryRoot`

The repository root the contracts sit under.

### outputs

`[string[]]` One finding per unknown type and per group that is not its module's.

### example 1

```powershell
Get-ContractTypeFindings -Version 0.1.0 -RepositoryRoot $root
```
