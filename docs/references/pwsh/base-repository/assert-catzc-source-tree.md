# pwsh/Base.Repository/Assert-CatzcSourceTree.ps1

The guard for catzc-only tools: silent when the working root is catzc's own repository, a named error otherwise.

## help

### synopsis

Throws unless the session runs catzc's own source tree.

### description

A guard for the tools that exist for catzc's own repository alone: the builder, catzc's README, dictionary and DRS-index generators, and the
other tools that read or write catzc's own module tree. It is true only in source mode ([DDR-RUNMODE](../../../drs/design/run-modes.md)),
where the code root is the repository's own code track. In build mode, a consumer's working root or a built bundle, it throws, naming the
tool and saying it runs in catzc's source tree only. A guard for a tool that checks whatever tracks the working root has is
[Assert-SourceTree](assert-source-tree.md).

### parameter `Command`

The name of the guarded tool, used in the error message. Defaults to the calling command's name.

### example 1

```powershell
Assert-CatzcSourceTree
```

### example 2

```powershell
Assert-CatzcSourceTree -Command 'Build-Modules'
```
