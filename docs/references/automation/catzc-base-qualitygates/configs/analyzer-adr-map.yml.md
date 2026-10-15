---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md
    kind: comment-page
    body_sha: eecfc11d89a6
    adrs:
      - ADR-AZ-CUSTOMER#3
---

# automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `analyzers:`.

```text
Maps each ENABLED PSScriptAnalyzer rule that enforces an ADR rule to the rule id(s) it enforces, cited in
the [index](/docs/adr/index.md) '#' form (ADR-<CODE>#<n>). This is the source for the 'pssa-rule' enforcer kind in the
Test-Automation rule-coverage report (Get-AnalyzerAdrCoverage): a rule listed here is credited as
mechanically enforced on every run, because the L2 PSScriptAnalyzer gate runs inside Test-Automation.

Both kinds appear: the custom Measure-* rules (automation/.scriptanalyzer/*.psm1) and the enabled built-ins.
A rule that maps to no ADR is simply absent. Every custom analyzer rule MUST appear here (integrity-tested),
so a new custom rule cannot ship unmapped; a built-in appears only when it genuinely enforces an ADR and is
enabled in PSScriptAnalyzerSettings.psd1. Shape is validated at load (the AnalyzerAdrMapConfig type); id
existence is checked by an integrity test, not at load (so config load stays hermetic — the
[ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)
pattern).
```
