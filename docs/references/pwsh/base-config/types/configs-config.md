# pwsh/Base.Config/types/ConfigsConfig.cs

The typed record for the config registry, `configs/configs.yml`, and its validity rules. The registry binds each shipped config name to the
C# config type `Get-Config` constructs it as; this type's only job is to enforce that shape at construction time, so a malformed registry
can never produce an instance.

## Data model

Under the top-level `configs` map, each entry is a map holding `type`, a non-blank C# type full name, and optionally `overridable`, a
boolean where absent means true. `configs` is the only top-level key, and an absent or empty `configs` map is valid.

## Properties

- **`configs`** — the registry as config name to type full name, in file order.
- **`sealedConfigs`** — the entries a consumer overlay may not change (`overridable: false`), the engine-intrinsic configs
  ([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)).
