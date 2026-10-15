---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md
    kind: comment-page
    body_sha: "408b8c709651"
---

# automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$ruleIds = Get-CatsAdrRuleIds`.

```text
The rule ids in '#' citation form, so they compare to the map. Plain assignment receives the comma-wrapped
getter result intact — @() would nest it.
```
