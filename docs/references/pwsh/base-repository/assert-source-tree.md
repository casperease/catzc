# pwsh/Base.Repository/Assert-SourceTree.ps1

The guard for tools that work on the catzc source tree: it throws a named error in build mode and is silent in source mode.

## help

### synopsis

Throws when the session runs a built Catzc package instead of the catzc source tree.

### description

A guard for tools that operate on the catzc source repository by definition — lint and format quality gates, dependency analysis over the
per-function files, test discovery, and authoring steps that write back into automation/. In build mode
([DDR-RUNMODE](../../../drs/design/run-modes.md)) those files are not where the loaded code lives, so the tool stops with a named error
instead of silently reading or writing the wrong tree. Silent in source mode.

### parameter `Command`

The name of the guarded tool, used in the error message. Defaults to the calling command's name.

### example 1

```powershell
Assert-SourceTree
```

### example 2

```powershell
Assert-SourceTree -Command 'Format-Types'
```
