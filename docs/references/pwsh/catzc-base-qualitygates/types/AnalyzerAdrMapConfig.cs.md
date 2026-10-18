# pwsh/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The analyzer -> ADR rule map of configs/analyzer-adr-map.yml: each ENABLED PSScriptAnalyzer rule that enforces an
ADR rule, mapped to the rule id(s) it enforces in the index's '#' citation form (ADR-<CODE>#<n>) — the source of
the 'pssa-rule' enforcer kind in the rule-coverage report (Get-AnalyzerAdrCoverage, Get-CatsRuleEnforcers).
Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.QualityGates.AnalyzerAdrMapConfig), so
Get-Config -Config analyzer-adr-map returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).

Load-time rules are SHAPE and citation GRAMMAR only:
  - only the top-level key 'analyzers', a required, non-empty map;
  - every analyzer rule name is non-empty and maps to at least one id;
  - each id is a well-formed 'ADR-<CODE>#<n>'.
That each id names a real rule, and that every custom analyzer is mapped, are cross-asset facts the
'analyzer-adr-map integrity' test checks — config load never reads the ADR tree or the .scriptanalyzer folder
(the [ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload) pattern — load stays hermetic).
```
