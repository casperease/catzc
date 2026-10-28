# pwsh/Base.QualityGates/types/SourceConventionsConfig.cs

The typed record for `configs/source-conventions.yml`: the source checks `Test-SourceConventions` runs beside its naming and one-function
conventions, and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An
omitted check takes every default of its type: gate mode, nothing exempt, no phrases. Property names mirror the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Checks

- **`engine_set`** — the engine set is never restated: no literal engine list in code, no partial or miscounted engine set in prose
  ([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). It is an
  `EngineSetCheck`.
- **`neutral_codes`** — a logic (L0) test's fixture data uses neutral rule codes, never a code the DRS index declares
  ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). It is a
  `SourceCheck`.
- **`track_root_literal`** — the files that may spell the modules track's place, each with its reason. The analyzer rule
  `NoTrackRootLiteral` reads it ([ADR-AUTO-LAYERS](../../../../drs/automation/layers.md)). It is a `SourceCheck`.
- **`test_file_name`** — the test files whose subject is no one function (a template, a feature, a carrier file), each named with its
  reason, so the `Verb-Noun.Tests.ps1` name check lets them pass
  ([ADR-PWSH-PESTER-PESTERTESTFILE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-pestertestfile)). It is a
  `SourceCheck`.
