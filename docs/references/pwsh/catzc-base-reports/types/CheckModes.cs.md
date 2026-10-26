# pwsh/Base.Reports/types/CheckModes.cs

The one parser of a check's mode setting (`CheckMode`), shared by every check config: `drs-checks.yml` in `Catzc.Base.Docs`, and `links.yml`
and `source-conventions.yml` in `Catzc.Base.QualityGates`.

## One parser

One parser keeps one accepted spelling and one error text
([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). An omitted mode is
`default(CheckMode)`, Gate, the default `CheckMode` declares once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Parse

`Parse` reads the mode under the `mode` key of a check's settings map, matched by name, case-insensitively; `raw` may be null. An omitted or
null mode is `default(CheckMode)`. A value that names no mode returns `default(CheckMode)` and sets `error` to the one message for it;
otherwise `error` is null.
