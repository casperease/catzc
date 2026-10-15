# docs/references/automation/catzc-azure/Get-AzureEnvironment.ps1.md

`automation/Catzc.Azure/Get-AzureEnvironment.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads configs/azure.yml via Get-Config and composes an ordered dictionary with the
environment's identity fields (name, shortcode, region, region_code) and the serving subscription
(via Get-AzureSubscription). The subscription is named directly — the deploy path resolves it from
the az session and passes it in — so it is an explicit input here. Asserts the subscription actually
serves the environment. The embedded subscription's optional `customer` is what renders into resource
names. See [ADR-AZ-DATAMOD#4](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod4).
```
