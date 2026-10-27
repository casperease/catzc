# ADR: Config reading in PowerShell — one reader cmdlet and the validator convention

## Rules: ADR-PWSH-CONFIG

### Rule ADR-PWSH-CONFIG-GETCONFIG

The one config reader (ADR-CONF-LOADING-CONFIGONEREADER) is `Get-Config -Config <name>`, public in `Catzc.Base.Config`. No function reads
a `configs/*.yml` file with `Get-Content` or a YAML parser of its own, and none keeps a `$script:` config cache.

- [One cmdlet](#one-cmdlet)

### Rule ADR-PWSH-CONFIG-ASSERTVALIDATOR

A PowerShell validator (ADR-CONF-LOADING-POWERSHELLVALIDATOR) runs through `Invoke-ConfigValidator` (`Catzc.Base.ConfigExtensions`):
`Assert-<TitleCase(name)>Config` by convention, or a function named with `-Validator`, run in the owning module's scope.
`Test-ConfigValidators` is its gate: every `Assert-<TitleCase(name)>Config` maps to a shipped config of its module.

- [The validator convention](#the-validator-convention)

## Context

[module-config-loading](../../configuration/module-config-loading.md) states how a config is read, cached and validated for any engine. This
record is how pwsh spells it.

### One cmdlet

A second reader beside `Get-Config` would be a second cache and a second validation path, and the two would disagree the first time a
config changed mid-session. A `$script:` cache is the usual way a function grows one, so it is named here as the shape to refuse.

### The validator convention

A naming convention finds the validator without a registry: the config's name in title case gives the function, and the owning module's
scope gives it the module's private helpers. `-Validator` names a function outside the convention, and the gate keeps every conventional
name tied to a config that ships, so an orphaned validator fails rather than lingering.

## Decision

pwsh reads every config through `Get-Config` and validates a config without a C# type through `Invoke-ConfigValidator` and the
`Assert-<TitleCase(name)>Config` convention, checked by `Test-ConfigValidators`.

## Consequences

- A reviewer looks for one cmdlet; a direct YAML read or a `$script:` config cache is the finding.
- A track's own config gets validation by shipping one private function with the conventional name.
