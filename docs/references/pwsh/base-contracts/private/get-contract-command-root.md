# pwsh/Base.Contracts/private/Get-ContractCommandRoot.ps1

The resolver from a contract group to the module whose command files the group's contracts describe. It throws when no module, or no
checkable language, stands behind the group.

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

## from group to module

The contract group is the group of an exception in the [contracts config](../configs/contracts.md), or else the module's track and its
folder in the normal form (the form Get-ContractGroup writes). The track renders the folder in PowerShell's folder case and gives back the
module's full name.
