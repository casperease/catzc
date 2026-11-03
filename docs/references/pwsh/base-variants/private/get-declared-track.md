# pwsh/Base.Variants/private/Get-DeclaredTrack.ps1

The module's one source of the track list `Get-Track` answers from: the variants config's tracks, with the engine's own track in front in
build mode.

## help

### synopsis

Returns the tracks of the running repository, the bundle's own track prepended in build mode.

### description

In source mode the list is the `tracks` variant as declared, the shipped `variants.yml` holding the `pwsh` track itself. In build mode the
`variants` config is the consumer's own, read whole from the working root, so it describes the consumer's repository and never catzc's; the
bundle's track (`pwsh`, namespace `Catzc`, type `modules`, engine `pwsh`) is engine knowledge, supplied in front of the consumer's tracks
with the code root, relative to the working root, as its one member. A consumer file naming the track `pwsh` or a `Catzc` namespace is
refused, naming [ADR-AUTO-CONSUMER-OWNTRACKS](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks).

### example 1

```powershell
Get-DeclaredTrack
```
