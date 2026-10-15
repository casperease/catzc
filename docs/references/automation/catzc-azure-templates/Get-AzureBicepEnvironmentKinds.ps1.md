# docs/references/automation/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md

`automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
'standard'     (default) — the template's configs use standard environments (dev/test/preprod/prod),
                           which may appear many-per-subscription.
'subscription'           — the template's configs use per-subscription environments (nsub/psub),
                           which appear exactly once per subscription. See
                           [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```
