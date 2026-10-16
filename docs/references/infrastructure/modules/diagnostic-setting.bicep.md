---
catzc:
  derived:
    path: docs/references/infrastructure/modules/diagnostic-setting.bicep.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d3aa109a893d
---

# infrastructure/modules/diagnostic-setting.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Kind of the target resource.')`, written with `//`.

```text
Reusable bicep module: a diagnostic setting that sends a resource's logs and metrics to a Log
Analytics workspace. A diagnostic setting attaches to a typed resource, so the caller names the
resource kind and the resource; the module picks the log and metric categories that kind exposes
(logs by the `allLogs` category group). The subscription's activity log has its own module
(subscription-diagnostic-setting.bicep). `az bicep build` inlines it.
```
