# pwsh/Base.QualityGates/types/SourceCheck.cs

The settings every source check shares, read from its key in a QualityGates config (`links.yml`'s `string_citations`,
`source-conventions.yml`'s `engine_set` and `neutral_codes`), and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). A check
with settings of its own derives from this type and names its extra keys, so one key set is validated in one place. Property names mirror
the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

- **`mode`** — `gate` (every finding fails the run; the default) or `report` (findings are printed and counted, and never fail it). A check
  is in report mode only while its work list is drained. The mode is `Catzc.Base.Reports.CheckMode`, whose zero value, `Gate`, is the one
  declared default, parsed by the one `Catzc.Base.Reports.CheckModes` parser.
- **`exempt`** — a repository-relative glob (the durable-sha-globs dialect) mapped to why the files it matches are left out of the check.
  Omitted, no file is exempt. Every reason is non-empty: an exception is a declared entry with its reason, never a list in code
  ([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)).
