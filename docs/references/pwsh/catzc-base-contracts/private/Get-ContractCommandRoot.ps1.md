# pwsh/Catzc.Base.Contracts/private/Get-ContractCommandRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the root folder of the module whose command contracts are being resolved, where its command files sit.

### description

A command contract names its command by placement
([ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-noplacementfacts)): the
module folder is the owner, and the command's file sits under the module's root beside its other public functions. The root comes from the
one resolver of a module, Get-CatzcModule
([ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule)), looked up
by name in the code track; no module of that name throws, naming the module. A module whose languages do not include PowerShell throws
NotImplemented: only the PowerShell checker exists
([ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-checkerperlanguage)).

### parameter `Module`

The owning module's name, the asset's module folder.

### parameter `RepositoryRoot`

The tree the module is resolved in.

### outputs

`[string]` The module's root, repository-relative and '/'-separated.

### example 1

```powershell
Get-ContractCommandRoot -Module Catzc.Base.Languages -RepositoryRoot $root
```
