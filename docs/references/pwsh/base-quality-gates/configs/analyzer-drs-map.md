# pwsh/Base.QualityGates/configs/analyzer-drs-map.yml

The map from each enabled PSScriptAnalyzer rule to the DRS rule codes it enforces. It is the source of the `pssa-rule` enforcer kind in the
Test-Automation rule-coverage report (Get-AnalyzerDrsCoverage).

## What it holds

Under `analyzers:`, each key is an enabled rule and its value is the list of rule codes it enforces. Both kinds of rule appear: the custom
`Measure-*` rules in `pwsh/.scriptanalyzer/*.psm1` and the enabled built-ins. A rule listed here is credited as mechanically enforced on
every run, because the L2 quality gate for PSScriptAnalyzer runs inside Test-Automation. A rule that maps to no rule is simply absent.

## Rules for the map

Every custom analyzer rule must appear here, and an integrity test enforces it, so a new custom rule cannot ship unmapped. A built-in
appears only when it genuinely enforces a rule and is enabled in `PSScriptAnalyzerSettings.psd1`.

## Validation

The shape is validated at load by the AnalyzerDrsMapConfig type. Whether each id exists is checked by an integrity test, not at load, so the
config load stays hermetic
([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated) sets the
same pattern).
