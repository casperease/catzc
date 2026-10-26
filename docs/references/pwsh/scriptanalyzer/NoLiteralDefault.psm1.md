# pwsh/.scriptanalyzer/NoLiteralDefault.psm1

The custom analyzer check `Measure-NoLiteralDefault`: in a module function that reads a registered config, a configured setting takes its
default from its config type, shown in the shipped config file, never from a literal in the function
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Config reads

The check follows the variables the function fills from a config read, directly (`$settings = Get-Config …`) or through a member of one.
