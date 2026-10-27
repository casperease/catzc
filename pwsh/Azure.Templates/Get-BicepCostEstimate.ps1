function Get-BicepCostEstimate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Template,

        [Catzc.Azure.Templates.CostModelConfig] $Config = (Get-Config -Config cost-model),

        [string] $PricesPath = (Join-Path $PSScriptRoot 'assets/cost-prices.json'),

        [string] $OutputRoot = (Get-BicepTemplatesOutputRoot),

        [string] $Subscription
    )

    # The estimate reads the template as Build-Bicep compiled it, so a module's resources count where the module is inlined.
    $mainJson = Join-Path $OutputRoot "$Template/main.json"
    Assert-PathExist $mainJson -PathType Leaf -ErrorText "Get-BicepCostEstimate: '$Template' has no compiled main.json at '$mainJson'; run Build-Bicep $Template first."
    $compiled = ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText($mainJson)) -AsHashtable

    $counts = @{}
    $walk = {
        param($Resources)
        # A languageVersion 2.0 template keys its resources by symbolic name; an older one lists them.
        $list = if ($Resources -is [System.Collections.IDictionary]) {
            @($Resources.Values)
        }
        else {
            @($Resources)
        }
        foreach ($resource in $list) {
            if ($resource -isnot [System.Collections.IDictionary]) {
                continue
            }
            # A resource declared with copy is counted once: the estimate is per declaration, its loop length a deploy-time value.
            $counts[$resource['type']] = 1 + ($counts.ContainsKey($resource['type']) ? $counts[$resource['type']] : 0)
            $inner = $resource['properties']
            if ($inner -is [System.Collections.IDictionary] -and $inner['template'] -is [System.Collections.IDictionary]) {
                & $walk $inner['template']['resources']
            }
        }
    }
    & $walk $compiled['resources']

    $prices = if (Test-Path -LiteralPath $PricesPath -PathType Leaf) {
        ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText($PricesPath)) -AsHashtable
    }
    else {
        @{}
    }
    $table = $prices['prices'] ?? @{}

    # A type whose SKU a config decides reads it at its global address for the subscription; with no subscription to read for, it has none,
    # and its SKU-bound meters apply nowhere.
    $skus = @{}
    foreach ($type in @($Config.skus.Keys)) {
        $address = $Config.skus[$type]
        $skus[$type] = if ($address.Contains('{subscription}')) {
            if ($Subscription) {
                "$(Get-ConfigValue $address.Replace('{subscription}', $Subscription))"
            }
        }
        else {
            "$(Get-ConfigValue $address)"
        }
    }

    $lines = foreach ($meter in $Config.meters) {
        if (-not $counts.ContainsKey($meter.type)) {
            continue
        }
        if ($meter.when_sku -and $meter.when_sku -cne $skus[$meter.type]) {
            continue
        }
        $count = if ($meter.count -gt 0) {
            $meter.count
        }
        else {
            $counts[$meter.type]
        }
        $price = $table[$meter.id]
        $unit = if ($price) {
            [double] $price['unit_price']
        }
        [pscustomobject]@{
            Meter     = $meter.id
            Type      = $meter.type
            Sku       = $skus[$meter.type]
            Count     = $count
            Quantity  = $meter.quantity
            UnitPrice = $unit
            Monthly   = if ($null -ne $unit) {
                [System.Math]::Round($count * $meter.quantity * $unit, 2)
            }
        }
    }
    $lines = @($lines)
    $priced = @($lines | Where-Object { $null -ne $_.Monthly })

    [pscustomobject]@{
        Template     = $Template
        Subscription = $Subscription
        Currency = $prices['currency'] ?? $Config.currency
        Region   = $prices['region'] ?? $Config.region
        AsOf     = $prices['as_of']
        Monthly  = [System.Math]::Round([double] (($priced | Measure-Object -Property Monthly -Sum).Sum ?? 0), 2)
        Budget   = [System.Math]::Round([double] (($priced | Measure-Object -Property Monthly -Sum).Sum ?? 0) * $Config.headroom, 2)
        Lines    = $lines
        Unpriced = [string[]] @($lines | Where-Object { $null -eq $_.Monthly } | ForEach-Object Meter)
    }
}
