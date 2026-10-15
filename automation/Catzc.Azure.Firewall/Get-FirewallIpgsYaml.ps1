<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/Get-FirewallIpgsYaml.ps1
    kind: public-function
    module: Catzc.Azure.Firewall
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Enumerates the IP Groups across one or more (subscription, resource group) targets into a single YAML.
.DESCRIPTION
    Each source is declared once, so the shared subscription and group stay off every IP Group entry.
.PARAMETER SubscriptionId
    Passed to az explicitly on every call, so the active CLI subscription is never switched.
.PARAMETER ResourceGroupName
    Doubles as the source key, so two targets with the same group name in one run collide and throw.
.PARAMETER YamlPath
    Output YAML path for the combined document. Defaults to <repo-root>/out/yaml/ipgs.yaml.
.EXAMPLE
    Get-FirewallIpgsYaml -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000 -ResourceGroupName rg-firewall
.EXAMPLE
    @(
        [pscustomobject]@{ SubscriptionId = $subA; ResourceGroupName = 'rg-fw-a' }
        [pscustomobject]@{ SubscriptionId = $subB; ResourceGroupName = 'rg-fw-b' }
    ) | Get-FirewallIpgsYaml -YamlPath .\docs\ipgs.yaml
#>
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
        # No connection assert: each target names its own subscription, so a missing session fails on the first call.
        # [comment:4](/docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md#comment4)
        Assert-AzCliExtension 'ip-group'

        # Each byte is padded to three digits so a string sort orders numerically; unparseable falls back to lexical.
        # [comment:5](/docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md#comment5)
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

        # Same group name under two subscriptions would collide on the source key, so throw rather than overwrite.
        # [comment:6](/docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md#comment6)
        if ($allSources.Contains($ResourceGroupName)) {
            if ($allSources[$ResourceGroupName].subscriptionId -ne $SubscriptionId) {
                throw "Source name collision: resource group '$ResourceGroupName' appears in two subscriptions ($($allSources[$ResourceGroupName].subscriptionId) and $SubscriptionId). Source names (resource group names) must be unique across targets."
            }
        }
        else {
            $allSources[$ResourceGroupName] = [ordered]@{ subscriptionId = $SubscriptionId }
        }

        foreach ($g in $groups) {
            # Names are unique per source, not across sources, so one source's group must not overwrite another's.
            # [comment:7](/docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md#comment7)
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
