# pwsh/Base.ModuleSystem/private/Get-ModuleGroupConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the declared module GROUPS from configs/dependencies.yml.

### description

A group is a named set of on-disk modules with its own internal dependency DAG — a concept, not a disk module. A consumer module's
allowed-deps list may name a group (which permits an edge to any member) and/or a specific module. The group's member->member map is the
layering contract that an ex-monolith enforced "inside one module".

Loads the optional top-level 'groups' map via Get-Config (same parse + validation + session cache as Get-ModuleDependencyConfig) and
projects each Catzc.Base.ModuleSystem.ModuleGroup to its member map. The returned object is an ordered dictionary: group name -> (read-only
ordered dictionary: member module -> list of members it may depend on). A file with no 'groups' key returns an empty ordered dictionary
(groups are optional).

### example 1

```powershell
(Get-ModuleGroupConfig)['Base']['Catzc.Base.Writers']
```
