# PowerShell: Config reading — one reader cmdlet and the validator convention

## Rules: ADR-PWSH-CONFIG

### Rule ADR-PWSH-CONFIG-GETCONFIG

The one config reader the configuration domain requires is `Get-Config -Config <name>`, public in `Catzc.Base.Config`. No function reads a
`configs/*.yml` file with `Get-Content` or a YAML parser of its own, and none keeps a `$script:` config cache.

- [One cmdlet](#one-cmdlet)

### Rule ADR-PWSH-CONFIG-ASSERTVALIDATOR

A PowerShell validator, the configuration domain's extension point for a config without a C# type, runs through `Invoke-ConfigValidator`
(`Catzc.Base.ConfigExtensions`): `Assert-<TitleCase(name)>Config` by convention, or a function named with `-Validator`, run in the owning
module's scope. `Test-ConfigValidators` is its gate: every `Assert-<TitleCase(name)>Config` maps to a shipped config of its module.

- [The validator convention](#the-validator-convention)

## Context

The configuration domain states how a config is read, cached and validated for any engine. This record is how pwsh spells it.

### One cmdlet

A second reader beside `Get-Config` is a second cache and a second validation path, and the two disagree as soon as a config changes
mid-session. A `$script:` cache is the usual way a function grows one, so it is the named shape to refuse.

### The validator convention

A naming convention finds the validator without a registry: the config's name in title case gives the function, and the owning module's
scope gives it the module's private helpers. `-Validator` names a function outside the convention, and the gate keeps every conventional
name tied to a config that ships, so an orphaned validator fails rather than lingering.

### Config addresses in pwsh

`How pwsh resolves a global config address`

The configuration domain states the `global.<config>.<key>[.<key>…]` address grammar for any engine. In pwsh the resolver is
`Get-ConfigValue -Address <address> [-Module <module>]` (public, `Catzc.Base.Config`):

```powershell
Get-ConfigValue -Address 'global.myproperty.name'                       # scalar leaf → the value at myproperty → name
Get-ConfigValue -Address 'global.database'                              # subtree     → the whole database config node
Get-ConfigValue -Address 'global.azure.environments.prod.region_code'   # deep leaf
```

A `ValidatePattern` on `-Address` rejects a malformed address at parameter binding. `Get-ConfigValue` strips `global.`, splits the rest into
`<config>` plus a key path, calls `Get-Config -Config <config> -Module <module>` (`-Module` is a passthrough for the rare name that exists
in two modules), and walks the key path with the private `Resolve-ConfigKeyPath`. The walk lives there alone, so `Get-ConfigValue` stays a
thin strip-split-walk and the walk is unit-testable in isolation. Per segment it resolves a **dictionary key** when the current node is an
`IDictionary`, otherwise a **property** on the node, so a raw ordered dictionary and a C# or `Assert-…`-validated object walk alike. An
unknown or ambiguous config name throws from `Get-Config` / `Resolve-ConfigEntry` (an ambiguous one asks for `-Module`), and a segment that
resolves at neither throws from `Resolve-ConfigKeyPath`, naming the full address and the failing segment; nothing returns `$null`.

## Decision

pwsh has one config reader and one validator convention, as the rules above state.

## Consequences

- A reviewer looks for one cmdlet; a direct YAML read or a `$script:` config cache is the finding.
- A track's own config gets validation by shipping one private function with the conventional name.
