Describe 'Update-AzurePriceTable' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Azure.Templates.CostModelConfig]::new(@{
                request_pause_ms = 250
                meters           = @(
                    @{ id = 'widget-vault-ops'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations'; quantity = 10 }
                    @{ id = 'widget-gadget'; type = 'Microsoft.Compute/virtualMachines'; service = 'Virtual Machines'; meter = 'B1s'; product = 'Gadget Series'; quantity = 730 }
                )
            })
        $script:item = {
            param($Price, $Tier)
            [pscustomobject]@{ retailPrice = $Price; unitOfMeasure = '10K'; skuName = 'Standard'; tierMinimumUnits = $Tier }
        }
        $script:refused = {
            param([System.Net.HttpStatusCode] $Status)
            $response = [System.Net.Http.HttpResponseMessage]::new($Status)
            $response.Headers.RetryAfter = [System.Net.Http.Headers.RetryConditionHeaderValue]::new([timespan]::FromSeconds(3))
            [Microsoft.PowerShell.Commands.HttpResponseException]::new("Response status code does not indicate success: $([int] $Status).", $response)
        }
    }

    BeforeEach {
        $script:path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).json"
        $script:uris = [System.Collections.Generic.List[string]]::new()
        $script:refusals = 0
        $script:refusal = [System.Net.HttpStatusCode]::TooManyRequests
        $script:free = $false
        Mock Start-Sleep -ModuleName Catzc.Azure.Templates { }
        Mock Invoke-RestMethod -ModuleName Catzc.Azure.Templates {
            # The URI is matched on its escaped text, as it goes on the wire.
            $wire = ([uri] $Uri).AbsoluteUri
            $script:uris.Add($wire)
            if ($script:refusals -gt 0) {
                $script:refusals--
                throw (& $script:refused $script:refusal)
            }
            if ($script:free -and $wire -like '*Key%20Vault*') {
                [pscustomobject]@{ Items = @((& $script:item 0 0), (& $script:item 0.02 5)); NextPageLink = $null }
            }
            elseif ($wire -like '*page=2*') {
                [pscustomobject]@{ Items = @(& $script:item 0.03 0); NextPageLink = $null }
            }
            elseif ($wire -like '*Key%20Vault*') {
                [pscustomobject]@{ Items = @(& $script:item 0.5 1000); NextPageLink = 'https://prices.azure.com/api/retail/prices?page=2' }
            }
            else {
                [pscustomobject]@{ Items = @(); NextPageLink = $null }
            }
        }
    }

    It 'asks once per meter, filtered by service, meter, region and product, follows the next page, and takes the first tier' {
        $result = Update-AzurePriceTable -Config $script:config -PricesPath $script:path -Today ([datetime]::new(2026, 10, 27))
        $result.Requests | Should -Be 3
        [uri]::UnescapeDataString($script:uris[0]) | Should -BeLike "*serviceName eq 'Key Vault' and meterName eq 'Operations' and armRegionName eq 'westeurope'*"
        [uri]::UnescapeDataString($script:uris[2]) | Should -BeLike "*productName eq 'Gadget Series'*"
        $written = Get-Content -Raw -LiteralPath $script:path | ConvertFrom-Json -AsHashtable
        $written['as_of'] | Should -Be '2026-10-27'
        $written['prices']['widget-vault-ops']['unit_price'] | Should -Be 0.03
        Should -Invoke Start-Sleep -ModuleName Catzc.Azure.Templates -Times 2 -Exactly -ParameterFilter { $Milliseconds -eq 250 }
    }

    It 'skips a free first tier and takes the first tier priced above 0' {
        $script:free = $true
        $null = Update-AzurePriceTable -Config $script:config -PricesPath $script:path
        (Get-Content -Raw -LiteralPath $script:path | ConvertFrom-Json -AsHashtable)['prices']['widget-vault-ops']['unit_price'] | Should -Be 0.02
    }

    It 'narrows the match to a meter''s sku when it names one' {
        $skued = [Catzc.Azure.Templates.CostModelConfig]::new(@{
                meters = @(@{ id = 'widget-vault-ops'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations'; sku = 'Standard'; quantity = 10 })
            })
        $null = Update-AzurePriceTable -Config $skued -PricesPath $script:path
        [uri]::UnescapeDataString($script:uris[0]) | Should -BeLike "*meterName eq 'Operations'*and skuName eq 'Standard'"
        $skued.meters[0].sku | Should -Be 'Standard'
        $script:config.meters[0].sku | Should -BeNullOrEmpty
    }

    It 'reads a meter in its own billing region when it names one, in place of the model''s region' {
        $zoned = [Catzc.Azure.Templates.CostModelConfig]::new(@{
                meters = @(@{ id = 'widget-zone'; type = 'Microsoft.Network/privateDnsZones'; service = 'Azure DNS'; meter = 'Private Zone'; region = 'Zone 1'; quantity = 1 })
            })
        $null = Update-AzurePriceTable -Config $zoned -PricesPath $script:path
        [uri]::UnescapeDataString($script:uris[0]) | Should -BeLike "*meterName eq 'Private Zone' and armRegionName eq 'Zone 1'*"
        $zoned.meters[0].region | Should -Be 'Zone 1'
    }

    It 'reports a meter its filter matches nothing for, and leaves it unpriced' {
        $result = Update-AzurePriceTable -Config $script:config -PricesPath $script:path
        $result.Unmatched | Should -Be @('widget-gadget')
        (Get-Content -Raw -LiteralPath $script:path | ConvertFrom-Json -AsHashtable)['prices'].Contains('widget-gadget') | Should -BeFalse
    }

    It 'waits as long as a 429 asks and retries once, then prices the meter' {
        $script:refusals = 1
        (Update-AzurePriceTable -Config $script:config -PricesPath $script:path).Priced | Should -Be 1
        Should -Invoke Start-Sleep -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter { $Seconds -eq 3 }
    }

    It 'throws naming the meter and its filter when a 429 comes twice, and writes nothing' {
        $script:refusals = 2
        { Update-AzurePriceTable -Config $script:config -PricesPath $script:path } |
            Should -Throw "*refused it twice with 429*Meter: widget-vault-ops. Filter: serviceName eq 'Key Vault'*"
        Test-Path -LiteralPath $script:path | Should -BeFalse
    }

    It 'throws on any other refusal at once, naming the meter and its filter' {
        $script:refusals = 1
        $script:refusal = [System.Net.HttpStatusCode]::BadRequest
        { Update-AzurePriceTable -Config $script:config -PricesPath $script:path } | Should -Throw '*failed:*400*Meter: widget-vault-ops. Filter:*'
        $script:uris.Count | Should -Be 1
    }

    It 'writes nothing with -DryRun' {
        $null = Update-AzurePriceTable -Config $script:config -PricesPath $script:path -DryRun
        Test-Path -LiteralPath $script:path | Should -BeFalse
    }

    It 'refuses a pause that is not a whole number of milliseconds' {
        { [Catzc.Azure.Templates.CostModelConfig]::new(@{ request_pause_ms = 1.5 }) } | Should -Throw '*request_pause_ms must be a whole number*'
    }
}
