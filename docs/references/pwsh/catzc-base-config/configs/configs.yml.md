# pwsh/Base.Config/configs/configs.yml

The config registry `Get-Config` reads: it binds every shipped config name to the C# config type that constructs it.

## Entries

`Test-ShippedConfigs` checks that each shipped `configs/<name>.yml` has an entry and loads, and that each entry names a shipped config. An
entry is:

```yaml
<config-name>:
  type: <C# FQN>
  overridable: false
```

- **`type`** — the type `Get-Config` constructs as `[FQN]::new($dict)`, which maps and validates the parsed file.
- **`overridable`** — optional; `false` seals the config against a consumer overlay (default `true`). Only the engine-intrinsic configs are
  sealed ([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)).

## Self-validation

The registry validates itself: the `configs` config, this file, is validated by the C# type `ConfigsConfig`, which `Get-ConfigRegistry`
constructs on load.
