function Update-AzurePriceTable {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Catzc.Azure.Templates.CostModelConfig] $Config = (Get-Config -Config cost-model),

        [string] $PricesPath = (Join-Path $PSScriptRoot 'assets/cost-prices.json'),

        [datetime] $Today = [datetime]::UtcNow.Date,

        [switch] $DryRun
    )

    # A manual refresh: nothing in CI or a build calls it, so a build never contacts the price service; the result is committed.
    $seconds = Get-TimeoutSeconds -Command Update-AzurePriceTable
    $base = "https://prices.azure.com/api/retail/prices?currencyCode=$($Config.currency)&`$filter="

    # One request per meter, a declared pause between them; a 429 waits as long as the service asks, within the limit, and retries once.
    $state = @{ Requests = 0 }
    $get = {
        param([string] $Uri, [string] $Filter, [string] $Meter)
        if ($state.Requests -gt 0) {
            Start-Sleep -Milliseconds $Config.request_pause_ms
        }
        $state.Requests++
        for ($attempt = 1; ; $attempt++) {
            try {
                return Invoke-RestMethod -Uri $Uri -Method Get -TimeoutSec $seconds
            }
            catch {
                $status = [int] $_.Exception.Response.StatusCode
                if ($status -ne 429 -or $attempt -ge 2) {
                    $reason = if ($status -eq 429) {
                        'refused it twice with 429 (Too Many Requests); run it again later'
                    }
                    else {
                        "failed: $($_.Exception.Message)"
                    }
                    throw "Update-AzurePriceTable: the Retail Prices API $reason. Meter: $Meter. Filter: $Filter"
                }
                $after = $_.Exception.Response.Headers.RetryAfter
                $wait = if ($after -and $after.Delta) {
                    $after.Delta.TotalSeconds
                }
                else {
                    $Config.request_pause_ms / 1000
                }
                Start-Sleep -Seconds ([System.Math]::Min([System.Math]::Max($wait, 0), $seconds))
            }
        }
    }

    $prices = [ordered]@{}
    $unmatched = [System.Collections.Generic.List[string]]::new()
    foreach ($meter in $Config.meters) {
        # A meter sold by billing zone, such as a DNS zone, reads its own region in place of the model's ARM region.
        $region = $meter.region ? $meter.region : $Config.region
        $filter = "serviceName eq '$($meter.service)' and meterName eq '$($meter.meter)' and armRegionName eq '$region' and priceType eq 'Consumption'"
        if ($meter.product) {
            $filter += " and productName eq '$($meter.product)'"
        }
        if ($meter.sku) {
            $filter += " and skuName eq '$($meter.sku)'"
        }
        $items = [System.Collections.Generic.List[object]]::new()
        $page = & $get ($base + [uri]::EscapeDataString($filter)) $filter $meter.id
        while ($true) {
            foreach ($item in @($page.Items)) {
                $items.Add($item)
            }
            if (-not $page.NextPageLink) {
                break
            }
            $page = & $get $page.NextPageLink $filter $meter.id
        }
        $first = @($items | Where-Object { [double] $_.retailPrice -gt 0 } | Sort-Object { [double] $_.tierMinimumUnits } | Select-Object -First 1)
        if ($first.Count -eq 0) {
            $unmatched.Add($meter.id)
            continue
        }
        $prices[$meter.id] = [ordered]@{ unit_price = [double] $first[0].retailPrice; unit_of_measure = "$($first[0].unitOfMeasure)"; sku = "$($first[0].skuName)" }
    }

    $document = [ordered]@{
        currency = $Config.currency
        region   = $Config.region
        as_of    = $Today.ToString('yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture)
        prices   = $prices
    }
    $changed = Write-FileIfChanged $PricesPath (($document | ConvertTo-Json -Depth 5) + "`n") -DryRun:$DryRun
    [pscustomobject]@{ Path = $PricesPath; Changed = $changed; Requests = $state.Requests; Priced = $prices.Count; Unmatched = [string[]] $unmatched }
}
