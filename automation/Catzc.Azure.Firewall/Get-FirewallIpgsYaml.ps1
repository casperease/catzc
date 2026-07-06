<#
.SYNOPSIS
    Enumerates the IP Groups across one or more (subscription, resource group) targets into a single YAML.
.DESCRIPTION
    Takes (subscription, resource group) targets from the pipeline and aggregates them into one YAML
    document with two root nodes: 'sources', declaring each source once (keyed by resource group name,
    holding its subscription), and 'ipgs', mapping each IP Group name to its source (the resource group
    name) and its sorted address prefixes (CIDRs, single IPs, or ranges). Declaring each source once keeps
    the shared subscription/RG off every entry, and a single document can hold many sources.

    Targets are taken from the pipeline by property name, so a set spanning multiple subscriptions can be
    piped in at once and collected into one file:

        @(
            [pscustomobject]@{ SubscriptionId = $subA; ResourceGroupName = 'rg-fw-a' }
            [pscustomobject]@{ SubscriptionId = $subB; ResourceGroupName = 'rg-fw-b' }
        ) | Get-FirewallIpgsYaml

    Each subscription is targeted explicitly with --subscription; the active CLI subscription is never
    switched, so this composes across subscriptions without Invoke-InSubscription. The begin block asserts
    once that the ip-group extension is installed (Assert-AzCliExtension); per-target failures (including a
    missing session) and empty resource groups throw with remediation. This is a management-plane read, so
    the identity needs Reader on each resource group.

    Source names are resource group names, so they must be unique across the targets piped in one run; two
    targets sharing a resource group name (in different subscriptions) collide and throw, as do two IP
    Groups sharing a name across sources. Groups and sources are emitted sorted by name; addresses are
    sorted numerically by their first IP, falling back to a lexical sort for anything that doesn't parse.

    The file opens with a comment header (counts, retrieval time in UTC); being YAML comments they're
    ignored by parsers. The single combined file's path is emitted.
.PARAMETER SubscriptionId
    A target subscription GUID. Passed explicitly to az, never switched. Bound from the pipeline by
    property name.
.PARAMETER ResourceGroupName
    A target resource group whose IP Groups are enumerated; also used as the source name. Bound from the
    pipeline by property name.
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
        # Assert once that the ip-group extension is present (fail fast with remediation instead of an
        # exit-2 / hang). No connection assert: each target is hit explicitly with --subscription, so
        # there's no single active subscription to assert; a missing session surfaces on the first call.
        Assert-AzCliExtension 'ip-group'

        # Numeric sort key from an address's first IP (handles CIDR a.b.c.d/p, range a-b, or a single IP);
        # pad each byte to 3 digits so a string sort orders numerically. Unparseable -> lexical fallback.
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

        # Register this target's source once (keyed by RG name). Two targets sharing an RG name but pointing
        # at different subscriptions would collide on the source key — surface that rather than overwrite.
        if ($allSources.Contains($ResourceGroupName)) {
            if ($allSources[$ResourceGroupName].subscriptionId -ne $SubscriptionId) {
                throw "Source name collision: resource group '$ResourceGroupName' appears in two subscriptions ($($allSources[$ResourceGroupName].subscriptionId) and $SubscriptionId). Source names (resource group names) must be unique across targets."
            }
        }
        else {
            $allSources[$ResourceGroupName] = [ordered]@{ subscriptionId = $SubscriptionId }
        }

        foreach ($g in $groups) {
            # IP Group names are unique within a source but not necessarily across sources — guard the
            # shared 'ipgs' map so one source's group can't silently overwrite another's.
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

        # Stable output: sort sources and groups by name regardless of the order targets arrived in.
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
