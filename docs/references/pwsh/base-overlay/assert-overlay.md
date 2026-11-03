# pwsh/Base.Overlay/Assert-Overlay.ps1

The check of the whole consumer overlay: it gathers every entry's violations and throws once with all of them, so a consumer sees every fix
at once. `Import-Overlay` runs it before it applies anything.

## help

### synopsis

Checks the consumer overlay against its rules and throws once, listing every violation.

### description

The overlay is the only place a consumer changes what a built bundle does, so it is checked as a whole before any of it is applied
([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)):

```text
Unknown           an entry that is no override point
Finding           a folder that names no bundled module: the overlay holds overrides of bundled modules only, and the
                  consumer's own modules live in its tracks
FunctionOverride  one function named for the file, loadable anywhere (Get-FunctionFileViolation); it replaces
                  a function the bundled module has, with the same visibility (a public override replaces an
                  exported function, a private one a function the module keeps to itself); it keeps the
                  original's contract (every parameter, with its type; no new mandatory parameter; the same
                  [OutputType]). A new function belongs in a module of the consumer's own tracks.
ConfigFragment    merges onto a config the module ships, and never onto a sealed one (configs.yml
                  scope: engine)
AssetOverride     replaces an asset the module ships; a new asset belongs in a module of the consumer's own tracks
```

The consumer's own modules are checked beside the overlay (Get-ConsumerModuleViolation), over every consumer track's modules: the namespace
is never Catzc, no public function takes the name of a command the bundle exports, no registry entry overrides a sealed catzc config in the
Catzc namespace, and types/ is allowed
([ADR-AUTO-CONSUMER-OWNTRACKS](../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks)). A consumer's CI runs it on
its own to fail early; Import-Overlay runs it before it applies anything.

### parameter `Entry`

The overlay entries to check (Get-Overlay). Defaults to the current overlay.

### example 1

```powershell
Assert-Overlay
```
