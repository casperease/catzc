# pwsh/.scriptanalyzer/FunctionLength.psm1

The custom analyzer check `Measure-FunctionLength`: a function body must not exceed the configured number of lines.

## The limit

The limit is `function_body_length` of `file-limits.yml` (300 as shipped), read once per process. The rule sits in the modules root, so it
reads that file from there, because an analyzer shard process has no `Get-Config`. When the file sets no value, the default declared on the
`FileLimitsConfig` type applies.

Help placed before the function is outside the braces, so it never counts toward the limit.

## Locating the config

Module folders resolve from their full names under the track's namespace, read before any import
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
