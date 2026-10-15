# docs/references/infrastructure/modules/diagnostic-setting.bicep.md

`infrastructure/modules/diagnostic-setting.bicep`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Kind of the target resource.')`.

```text
Reusable bicep module: a diagnostic setting that sends a resource's logs and metrics to a Log
Analytics workspace. A diagnostic setting attaches to a typed resource, so the caller names the
resource kind and the resource; the module picks the log and metric categories that kind exposes
(logs by the `allLogs` category group). The subscription's activity log has its own module
(subscription-diagnostic-setting.bicep). `az bicep build` inlines it.
```
