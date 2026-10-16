---
catzc:
  immutable:
    with_body_sha: "4a5ce799dba2"
    path: docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: test-analyzer-adr-map-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$ruleIds = Get-CatsAdrRuleIds`, written with `#`.

```text
The rule ids in '#' citation form, so they compare to the map. Plain assignment receives the comma-wrapped
getter result intact — @() would nest it.
```
