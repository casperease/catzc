# pwsh/Base.QualityGates/types/ParameterConsistencyConfig.cs

The typed record for `configs/parameter-consistency.yml`: the parameter names `Test-ParameterConsistency` lets carry more than one type
across the public functions ([ADR-PWSH-PARAM](../../../../drs/automation/pwsh/parameter-design.md)), and the single declaration of its
sensible default
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). Property
names mirror the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

- **`exempt`** — parameter name, without the dash, mapped to why the same name means a different thing in different functions. Omitted, no
  parameter is exempt. A name is matched case-insensitively, and every reason is non-empty.
