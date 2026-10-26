function Get-FirewallIpgsYaml {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [string]$SubscriptionId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1)]
        [string]$ResourceGroupName,

        [Parameter()]
        [string]$YamlPath = (Join-Path (Join-Path (Join-Path (Get-RepositoryRoot) 'out') 'yaml') 'ipgs.yaml')
    )

    begin {
        # Only the extension is asserted, since each target names its own subscription and a missing session fails that call.
        Assert-AzCliExtension 'ip-group'

        # Each byte pads to three digits so a string sort is a numeric one; an unparseable address sorts as text.
        $addressSortKey = {
            param([string]$Address)
            $first = ($Address -split '[-/]')[0].Trim()
            try {
                $bytes = [System.Net.IPAddress]::Parse($first).GetAddressBytes()
                ($bytes | ForEach-Object { $_.ToString('000') }) -join '.'
            }
            catch {
                $Address
            }
        }

        # Accumulate across every piped target, then write one combined document in end.
        $allSources = [ordered]@{}
        $allIpgs = [ordered]@{}
    }

    process {
        try {
            # Data read (-o json, parsed below) — silenced so the listing doesn't echo to the console.
            $cli = Invoke-AzCli "network ip-group list --resource-group $ResourceGroupName --subscription $SubscriptionId -o json" -PassThru -Silent
        }
        catch {
            throw (
                "Failed to list IP Groups in resource group '$ResourceGroupName' (subscription $SubscriptionId). " +
                "Check you're signed in (az login), the resource group exists, and your identity has Reader on it. Underlying: $_"
            )
        }
        $groups = @($cli.Output | ConvertFrom-Json)

        if (-not $groups.Count) {
            throw "No IP Groups found in resource group '$ResourceGroupName' (subscription $SubscriptionId). Wrong RG or missing access?"
        }

        # Sources key on resource group, so two subscriptions sharing one collide loudly instead of overwriting.
        if ($allSources.Contains($ResourceGroupName)) {
            if ($allSources[$ResourceGroupName].subscriptionId -ne $SubscriptionId) {
                throw "Source name collision: resource group '$ResourceGroupName' appears in two subscriptions ($($allSources[$ResourceGroupName].subscriptionId) and $SubscriptionId). Source names (resource group names) must be unique across targets."
            }
        }
        else {
            $allSources[$ResourceGroupName] = [ordered]@{ subscriptionId = $SubscriptionId }
        }

        foreach ($g in $groups) {
            # Group names are unique within one source only, so a clash across sources throws rather than replaces.
            if ($allIpgs.Contains($g.name)) {
                throw "IP Group name collision: '$($g.name)' exists under more than one source ('$($allIpgs[$g.name].source)' and '$ResourceGroupName'). IP Group names must be unique across targets."
            }
            $allIpgs[$g.name] = [ordered]@{
                source    = $ResourceGroupName
                addresses = @(@($g.ipAddresses) | Sort-Object { & $addressSortKey $_ })
            }
        }
    }

    end {
        if (-not $allIpgs.Count) {
            throw 'No IP Groups collected — no targets were supplied on the pipeline.'
        }

        # Stable output: sort the sources and groups by name regardless of the order targets arrived in.
        $sortedSources = [ordered]@{}
        foreach ($k in ($allSources.Keys | Sort-Object)) {
            $sortedSources[$k] = $allSources[$k]
        }
        $sortedIpgs = [ordered]@{}
        foreach ($k in ($allIpgs.Keys | Sort-Object)) {
            $sortedIpgs[$k] = $allIpgs[$k]
        }

        $doc = [ordered]@{
            'sources' = $sortedSources
            'ipgs'    = $sortedIpgs
        }

        $yaml = ConvertTo-Yaml -Data $doc

        # Provenance header — YAML comments, ignored by parsers. Retrieval time in UTC.
        $header = [System.Collections.Generic.List[string]]::new()
        $header.Add("# IP Groups - $($sortedSources.Count) source(s), $($sortedIpgs.Count) group(s)")
        $header.Add("# Retrieved: $([datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)) UTC")
        $yaml = ($header -join "`n") + "`n`n" + $yaml

        $outputDir = Split-Path -Path $YamlPath -Parent
        if ($outputDir -and -not (Test-Path -Path $outputDir)) {
            New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
        }

        Set-Content -Path $YamlPath -Value $yaml -Encoding UTF8
        Assert-PathExist $YamlPath -PathType Leaf
        Write-Message "wrote $YamlPath"

        $YamlPath
    }
}
