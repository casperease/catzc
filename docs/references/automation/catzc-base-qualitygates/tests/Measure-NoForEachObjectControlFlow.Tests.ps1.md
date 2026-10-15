---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Measure-NoForEachObjectControlFlow.Tests.ps1.md
    kind: test-asset
    body_sha: acbe48adc862
---

# automation/Catzc.Base.QualityGates/tests/Measure-NoForEachObjectControlFlow.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:emptySettings = @{ IncludeRules =...`.

```text
Empty settings prevents PSSA from auto-discovering PSScriptAnalyzerSettings.psd1
(which already lists this rule in CustomRulePath, causing double invocation).
```
