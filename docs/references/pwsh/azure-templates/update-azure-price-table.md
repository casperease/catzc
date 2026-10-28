# pwsh/Azure.Templates/Update-AzurePriceTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Refreshes the committed Azure price table from the Retail Prices API, one request per cost-model meter.

### description

A manual refresh: nothing in CI or a build calls it. For each meter of the cost-model config it queries the Retail Prices API by service,
meter name, region (the meter's own region, else the model's) and the consumption price type, narrowed by the meter's product and SKU when
it has them, and follows the result's next-page links. It pauses the configured time between requests; a 429 response waits as long as the
service asks, within the command's time limit, and retries once, and any other failure, or a second 429, throws with the meter and filter.

A meter takes the first tier priced above 0; a meter with none is reported as unmatched. The table, with currency, region and the as-of
date, is written to `-PricesPath` only when its content changes. The result holds the path, whether it changed, the request count, the
priced count and the unmatched meter ids. Get-BicepCostEstimate reads the table.

### parameter `Config`

The cost-model configuration, default read with `Get-Config -Config cost-model`.

### parameter `PricesPath`

The price table file to write, default `assets/cost-prices.json` of the module.

### parameter `Today`

The date written as the table's as-of date, default today in UTC.

### parameter `DryRun`

Queries the service and builds the table but writes no file.

### outputs

`[pscustomobject]`

### example 1

```powershell
Update-AzurePriceTable -DryRun
```

## comment:1

Above `$prices = [ordered]@{}`, written with `#`.

```text
Each meter takes the first tier priced above 0, since a free allowance is a meter's common first tier; a meter that matches
nothing is reported, never loosened.
```
