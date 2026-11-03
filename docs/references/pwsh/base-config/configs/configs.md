# pwsh/Base.Config/configs/configs.yml

The config registry `Get-Config` reads: it binds every shipped config name to the C# config type that constructs it.

## Entries

`Test-ShippedConfigs` checks that each shipped `configs/<name>.yml` has an entry and loads, and that each entry names a shipped config. An
entry is:

```yaml
<config-name>:
  type: <C# FQN>
  scope: engine
```

- **`type`** — the type `Get-Config` constructs as `[FQN]::new($dict)`, which maps and validates the parsed file.
- **`scope`** — optional, `module` when absent. `engine` seals the config against a consumer overlay; only the engine-intrinsic configs are
  sealed ([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)). `module` lets a `.catzc/` fragment merge key by key.
  `working-root` marks a config that describes the repository, read whole from the working root's `.catzc/configs/<name>.yml` in build mode
  and never merged onto the bundled file.

## Self-validation

The registry validates itself: the `configs` config, this file, is validated by the C# type `ConfigsConfig`, which `Get-ConfigRegistry`
constructs on load.
