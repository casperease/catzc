# pwsh/Azure.Templates/configs/cost-model.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `request_pause_ms: 5000 # the Retail Prices API refused the fifth request at...`, written with `#`.

```text
Each metered resource type the templates deploy, its retail meter as the Retail Prices API names it, and the monthly quantity one
resource uses. Update-AzurePriceTable reads the prices for these meters into assets/cost-prices.json; Get-BicepCostEstimate prices a
compiled template through both. currency, region and headroom keep their defaults on CostModelConfig.
```
