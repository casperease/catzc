# docs/references/infrastructure/modules/storage-account.bicep.md

`infrastructure/modules/storage-account.bicep`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Storage account name (3-24 lowercase alphanumeric, globally...`.

```text
Reusable bicep module: a StorageV2 account with the Well-Architected defaults — zone-redundant
(ZRS), no public network access, TLS 1.2 minimum, HTTPS only, no anonymous blob access, no shared-key
access, a system-assigned managed identity, and soft delete on blobs and containers. Reach it through
a private endpoint (../../modules/private-endpoint.bicep, group id `blob`). Templates reference it
with a relative `module` declaration (e.g. ../../modules/storage-account.bicep from a template's
main.bicep). `az bicep build` inlines the module into each template's main.json, so nothing from
infrastructure/modules/ ships separately at deploy time.

Modules live in infrastructure/modules/ and are NOT discovered as templates (Get-BicepTemplates
scans only infrastructure/templates/).
```
