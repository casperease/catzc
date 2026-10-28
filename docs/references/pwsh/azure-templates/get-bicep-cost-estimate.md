# pwsh/Azure.Templates/Get-BicepCostEstimate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Estimates a template's monthly cost from its compiled resources, the cost-model meters and the committed price table.

### description

Reads the main.json that Build-Bicep wrote to the template's output folder and counts its resources by type, a module's resources counted
where the module is inlined and a resource declared with copy counted once. It throws when the template has no compiled main.json.

Each meter of the cost-model config applies when its resource type is present and, for a meter with `when_sku`, when the type's SKU equals
it. A SKU the config reads at a `{subscription}` address is read for the `-Subscription` given and is empty without one. A meter's count is
its own `count` when above 0, else the number of resources of its type. A meter's unit price comes from the price table at `-PricesPath` (a
missing file is an empty table), and its monthly cost is count times quantity times unit price, rounded to two decimals. A meter with no
price is listed under Unpriced and adds nothing to the total.

The result holds the template, subscription, currency, region and as-of date (the table's, else the config's), the Monthly total, the Budget
(Monthly times the config's headroom), the Lines per meter and the Unpriced meter ids. Update-AzurePriceTable refreshes the table.

### parameter `Template`

Template name (folder under the compiled output root).

### parameter `Config`

The cost-model configuration, default read with `Get-Config -Config cost-model`.

### parameter `PricesPath`

The price table file, default `assets/cost-prices.json` of the module.

### parameter `OutputRoot`

The folder holding each template's compiled output, default Get-BicepTemplatesOutputRoot.

### parameter `Subscription`

The subscription whose configured SKUs select the SKU-bound meters; without it those meters apply nowhere.

### outputs

`[pscustomobject]`

### example 1

```powershell
Get-BicepCostEstimate foundation -Subscription discovery | Select-Object Template, Monthly, Budget, Unpriced
```

## comment:1

Above `$skus = @{}`, written with `#`.

```text
A type whose SKU a config decides reads it at its global address for the subscription; with no subscription to read for, it has none,
and its SKU-bound meters apply nowhere.
```
