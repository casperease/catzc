<#
.SYNOPSIS
    Downloads the newest firewall-rule CSV(s) from a blob container — one per requested rule type.
.DESCRIPTION
    For each requested -Type (application and/or network), locates the newest matching *.csv in the container and...
    [comment:1](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the az session must be set to. Asserted, not switched.
.PARAMETER StorageAccountName
    The storage account holding the exports.
.PARAMETER ContainerName
    The blob container within the account to search.
.PARAMETER Type
    Which rule type(s) to fetch: 'application', 'network', or both (the default when omitted).
    [comment:2](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment2)
.PARAMETER DownloadPath
    Destination directory.
    [comment:3](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment3)
.PARAMETER TimestampPattern
    Regex capturing the timestamp substring in the filename. Default '\d{2}-\d{2}-\d{4}-\d{2}-\d{2}'.
.PARAMETER TimestampFormat
    .NET ParseExact format for the captured timestamp, interpreted as UTC. Default 'dd-MM-yyyy-HH-mm'.
.EXAMPLE
    Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports
.EXAMPLE
    Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports -Type application
.EXAMPLE
    Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
        Convert-FirewallCsvToMarkdown -OutputFolder .\docs
#>
function Get-FirewallCsv {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'TimestampPattern/TimestampFormat are consumed inside the $parseStamp nested scriptblock, which this rule does not trace')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$SubscriptionId,

        [Parameter(Mandatory, Position = 1)]
        [string]$StorageAccountName,

        [Parameter(Mandatory, Position = 2)]
        [string]$ContainerName,

        [Parameter()]
        [string]$DownloadPath = (Join-Path (Get-OutputRoot) 'download'),

        # One or both rule types.
        # [comment:4](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment4)
        [Parameter()]
        [ValidateSet('application', 'network')]
        [string[]]$Type = @('application', 'network'),

        # Timestamp embedded in the filename (UTC) — the source of truth for generation time.
        [Parameter()]
        [string]$TimestampPattern = '\d{2}-\d{2}-\d{4}-\d{2}-\d{2}',

        [Parameter()]
        [string]$TimestampFormat = 'dd-MM-yyyy-HH-mm'
    )

    Assert-AzCliConnected -SubscriptionId $SubscriptionId

    # Pin to absolute: Invoke-Executable runs az from the repo root, so a relative --file would resolve there while...
    # [comment:5](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment5)
    $DownloadPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DownloadPath)

    if (-not (Test-Path -Path $DownloadPath)) {
        New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
    }

    # Shared args, as a string for Invoke-AzCli.
    # [comment:6](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment6)
    $common = "--subscription $SubscriptionId --account-name $StorageAccountName --container-name $ContainerName --auth-mode login"

    try {
        # --num-results *: list order is lexicographic by name, not by date — and the dd-MM-yyyy names don't sort...
        # [comment:7](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment7)
        $cli = Invoke-AzCli "storage blob list $common --num-results * -o json" -PassThru -Silent
    }
    catch {
        throw (
            "Failed to list blobs in container '$ContainerName' of '$StorageAccountName'. " +
            "Ensure your identity has 'Storage Blob Data Reader' on the account. " +
            "Underlying: $_"
        )
    }
    $blobs = @($cli.Output | ConvertFrom-Json)

    # Extract the UTC timestamp from a blob name. Returns $null if the name carries no parseable stamp.
    $utcStyles = [System.Globalization.DateTimeStyles]::AssumeUniversal -bor [System.Globalization.DateTimeStyles]::AdjustToUniversal
    $parseStamp = {
        param([string]$Name)
        if ($Name -notmatch $TimestampPattern) {
            return $null
        }   # no stamp at all: not one of our exports, skip
        $stamp = $Matches[0]
        $dateTime = [datetime]::MinValue
        if (-not [datetime]::TryParseExact($stamp, $TimestampFormat, [System.Globalization.CultureInfo]::InvariantCulture, $utcStyles, [ref]$dateTime)) {
            throw "Blob '$Name' has a timestamp-shaped segment '$stamp' that won't parse as '$TimestampFormat' — refusing to guess."
        }
        $dateTime
    }

    # Newest *.csv matching a name pattern, ranked by the filename timestamp (the source of truth).
    $pickNewest = {
        param([object[]]$All, [string]$Pattern)
        $candidates =
        $All |
            Where-Object { $_.name -match '\.csv$' -and $_.name -match $Pattern } |
            ForEach-Object { [pscustomobject]@{ Blob = $_; Generated = (& $parseStamp $_.name) } } |
            Where-Object { $null -ne $_.Generated } |
            Sort-Object Generated -Descending
        $candidates = @($candidates)
        if (-not $candidates.Count) {
            throw "No CSV matching /$Pattern/ with a parseable /$TimestampPattern/ timestamp in container '$ContainerName' of '$StorageAccountName'."
        }
        $candidates[0]
    }

    foreach ($ruleType in $Type) {
        $pick = & $pickNewest $blobs $ruleType      # the type word is the name filter
        $blob = $pick.Blob
        $blobName = $blob.name
        $destination = Join-Path $DownloadPath (Split-Path -Path $blobName -Leaf)

        Write-Verbose "Downloading $ruleType : $blobName (generated $($pick.Generated.ToString('u'))) -> $destination"
        try {
            # Quote --name and --file: blob names and the repo path may contain spaces.
            # [comment:8](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment8)
            Invoke-AzCli "storage blob download $common --name `"$blobName`" --file `"$destination`" --overwrite true -o none"
        }
        catch {
            throw "Failed to download blob '$blobName' to '$destination'. Underlying: $_"
        }

        # az can exit 0 yet leave no file (e.g.
        # [comment:9](/docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md#comment9)
        Assert-PathExist $destination -PathType Leaf -ErrorText "Blob '$blobName' reported success but no file is at '$destination'."

        [Catzc.Azure.Firewall.CsvExportRef]::new($ruleType, $destination, $pick.Generated, $blobName, $blob.properties.lastModified)
    }
}
