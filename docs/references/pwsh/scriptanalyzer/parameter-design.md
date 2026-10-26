# pwsh/.scriptanalyzer/ParameterDesign.psm1

The custom analyzer check module for a function's parameter surface ([ADR-PWSH-PARAM](../../../drs/automation/pwsh/parameter-design.md)).

## Which functions

The checks run over the functions in a module function file: a `.ps1` directly under `pwsh/<Module>/` (public) or under
`pwsh/<Module>/private/` (private), whose module folder is not dot-prefixed. The check decides by the file path, so an in-memory definition
with no file name is not checked.

## The checks

The module exports five checks, each a `Measure-*` function:

- `Measure-ParameterFillIn`
- `Measure-PrimaryArgumentPosition`
- `Measure-NoOptionalBooleanParameter`
- `Measure-NoSwitchDefaultOn`
- `Measure-CaseSensitivePattern`

Two of them have rules worth stating:

- **Primary argument position.** Public functions only: a positional primary argument serves the module's callers, while a private helper is
  called by name from inside its module.
- **Optional boolean.** A `[bool]` whose default reads the configuration is a configurable setting
  ([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)), not opt-in
  behaviour, and is not flagged.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
