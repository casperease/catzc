# pwsh/Base.QualityGates/types/AnalyzerDrsMapConfig.cs

The typed record for `configs/analyzer-drs-map.yml`: each enabled PSScriptAnalyzer rule that enforces a decision-record rule, mapped to the
rule codes it enforces. It is the source of the `pssa-rule` enforcer kind in the rule-coverage report (`Get-AnalyzerDrsCoverage`,
`Get-RuleEnforcers`). It is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config analyzer-drs-map` returns it.
Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one throw:

- the only top-level key is `analyzers`, a required, non-empty map;
- every analyzer rule name is non-empty and maps to at least one id;
- each id is a well-formed rule code of any registered kind.

Load checks shape and citation grammar only. That each id names a real rule, and that every custom analyzer is mapped, is a cross-asset fact
the analyzer-ADR-map integrity test checks. Loading never reads the decision-record tree or the `.scriptanalyzer` folder, so it stays
hermetic, the pattern of
[ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated).
