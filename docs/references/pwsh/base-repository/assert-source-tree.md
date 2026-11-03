# pwsh/Base.Repository/Assert-SourceTree.ps1

The guard for tools that check the tracks of the working root: silent in catzc's source tree and in a consumer root that declares tracks, a
named error otherwise.

## help

### synopsis

Throws when the working root has no tracks to check.

### description

A guard for the generic tools that operate on the tracks of the working root: lint and format quality gates, dependency analysis over the
per-function files, test discovery, and authoring steps that write back into the tracks. It is silent in source mode
([DDR-RUNMODE](../../../drs/design/run-modes.md)) and in build mode when the working-root variants file, `.catzc/configs/variants.yml`,
declares at least one track under `tracks`. A built root with no consumer tracks has nothing to check, so the tool stops with a named error
that says what a consumer declares
([ADR-AUTO-CONSUMER-OWNTRACKS](../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks)).

The variants file is read directly rather than through `Get-Track`: the Variants module depends on Config, and Config on this module, so
this module cannot call it. The check is the one `Resolve-ConfigEntry` makes for the consumer's tracks, a track entry in that file. A tool
that only catzc's own repository can run is guarded by [Assert-CatzcSourceTree](assert-catzc-source-tree.md).

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

## comment:1

Above `$variantsPath = [System.IO.Path]::Combine((Get-RepositoryRoot), '.catzc',...`, written with `#`.

```text
Get-Track is out of reach (Variants depends on Config, Config on Repository), so the working root's variants file is read directly,
the file Resolve-ConfigEntry gates the consumer's tracks on.
```
