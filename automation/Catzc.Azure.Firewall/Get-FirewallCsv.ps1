<#
.SYNOPSIS
    Downloads the newest firewall-rule CSV(s) from a blob container — one per requested rule type.
.DESCRIPTION
    For each requested -Type (application and/or network), locates the newest matching *.csv in the
    container and downloads it to <repo>/out/download (overridable via -DownloadPath). Emits one flat
    object per type as a stream, so the default (both types) yields two objects.

    "Newest" is decided by the UTC timestamp embedded in the filename (e.g. ...-16-06-2026-10-32.csv),
    which is the source of truth for generation time — not blob last-modified. A matching blob whose name
    carries no parseable timestamp is ignored; if none qualifies for a type, the function throws.

    Data-plane access goes through the az CLI with AAD auth (--auth-mode login), so no account key or
    resource group is required — the caller's identity needs the 'Storage Blob Data Reader' role on the
    account (or container). The session is asserted onto the expected subscription first via
    Assert-AzCliConnected, which fails fast with remediation if az is not logged in or set elsewhere.

    Each emitted object — Type, Path, Generated (UTC), Blob, Modified — pipes straight into
    Convert-FirewallCsvToMarkdown.
.PARAMETER SubscriptionId
    The subscription GUID the az session must be set to. Asserted, not switched.
.PARAMETER StorageAccountName
    The storage account holding the exports.
.PARAMETER ContainerName
    The blob container within the account to search.
.PARAMETER Type
    Which rule type(s) to fetch: 'application', 'network', or both (the default when omitted). The type
    word is also used as the case-insensitive name filter for selecting the blob.
.PARAMETER DownloadPath
    Destination directory. Defaults to <repo-root>/out/download. Created if absent.
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
        [string]$DownloadPath = (Join-Path (Join-Path (Get-RepositoryRoot) 'out') 'download'),

        # One or both rule types. Empty/omitted = both. The type word also serves as the name filter
        # ('application' matches ...ApplicationRules..., 'network' matches ...NetworkRules...).
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

    # Pin to absolute: Invoke-Executable runs az from the repo root, so a relative --file would resolve
    # there while New-Item resolves against $PWD. Make them agree before anyone touches the path.
    $DownloadPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DownloadPath)

    if (-not (Test-Path -Path $DownloadPath)) {
        New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
    }

    # Shared args, as a string for Invoke-AzCli. Sub/account/container are token-safe (no spaces).
    # --auth-mode login: ride the AAD session asserted above rather than fetching an account key.
    $common = "--subscription $SubscriptionId --account-name $StorageAccountName --container-name $ContainerName --auth-mode login"

    try {
        # --num-results *: list order is lexicographic by name, not by date — and the dd-MM-yyyy names
        # don't sort chronologically — so fetch every blob and let the filename-timestamp sort below decide.
        # -Silent here only: this is a data read (-o json, parsed below), not an action. Without it the
        # entire listing echoes to the console. The download call stays loud — that one is a real action.
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

    if (-not $Type) {
        $Type = @('application', 'network')
    }

    foreach ($ruleType in $Type) {
        $pick = & $pickNewest $blobs $ruleType      # the type word is the name filter
        $blob = $pick.Blob
        $blobName = $blob.name
        $destination = Join-Path $DownloadPath (Split-Path -Path $blobName -Leaf)

        Write-Verbose "Downloading $ruleType : $blobName (generated $($pick.Generated.ToString('u'))) -> $destination"
        try {
            # Quote --name and --file: blob names and the repo path may contain spaces.
            # -o none keeps az quiet; stream mode doesn't leak to the pipeline, so no Out-Null needed.
            Invoke-AzCli "storage blob download $common --name `"$blobName`" --file `"$destination`" --overwrite true -o none"
        }
        catch {
            throw "Failed to download blob '$blobName' to '$destination'. Underlying: $_"
        }

        # az can exit 0 yet leave no file (e.g. a silent partial). Confirm the download landed before
        # emitting an object that claims this Path, so a downstream consumer never trusts a missing file.
        Assert-PathExist $destination -PathType Leaf -ErrorText "Blob '$blobName' reported success but no file is at '$destination'."

        [Catzc.Azure.Firewall.CsvExportRef]::new($ruleType, $destination, $pick.Generated, $blobName, $blob.properties.lastModified)
    }
}
