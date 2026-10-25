<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-firewall/Get-FirewallCsv.ps1.md"
  header: "generated"
---
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

        [Parameter()]
        [ValidateSet('application', 'network')]
        [string[]]$Type = @('application', 'network'),

        [Parameter()]
        [string]$TimestampPattern = '\d{2}-\d{2}-\d{4}-\d{2}-\d{2}',

        [Parameter()]
        [string]$TimestampFormat = 'dd-MM-yyyy-HH-mm'
    )

    Assert-AzCliConnected -SubscriptionId $SubscriptionId

    # Pinned to absolute, so the CLI and the file system resolve one path the same way whatever folder each runs from.
    $DownloadPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DownloadPath)

    if (-not (Test-Path -Path $DownloadPath)) {
        New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
    }

    # Login auth rides the session already asserted, so no account key is ever fetched; these tokens hold no spaces.
    $common = "--subscription $SubscriptionId --account-name $StorageAccountName --container-name $ContainerName --auth-mode login"

    try {
        # Every blob is listed, because the day-first names never sort by date; the newest is picked from the names below.
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
            # Name and file are quoted, because either may hold spaces; the download stays loud because it is a real action.
            Invoke-AzCli "storage blob download $common --name `"$blobName`" --file `"$destination`" --overwrite true -o none"
        }
        catch {
            throw "Failed to download blob '$blobName' to '$destination'. Underlying: $_"
        }

        # The CLI can exit cleanly and leave no file, so the download is confirmed before any object claims that path.
        Assert-PathExist $destination -PathType Leaf -ErrorText "Blob '$blobName' reported success but no file is at '$destination'."

        [Catzc.Azure.Firewall.CsvExportRef]::new($ruleType, $destination, $pick.Generated, $blobName, $blob.properties.lastModified)
    }
}
