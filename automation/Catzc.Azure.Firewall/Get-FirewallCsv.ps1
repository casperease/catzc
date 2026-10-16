<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/Get-FirewallCsv.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Firewall
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md
      test: automation/Catzc.Azure.Firewall/tests/Get-FirewallCsv.Tests.ps1
  config:
    synopsis: Downloads the newest firewall-rule CSV(s) from a blob container — one per requested rule type.
    description: |-
      For each requested -Type (application and/or network), locates the newest matching *.csv in the
      container and downloads it to the output root's download folder (overridable via -DownloadPath). Emits one flat
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
    parameters:
      SubscriptionId: The subscription GUID the az session must be set to. Asserted, not switched.
      StorageAccountName: The storage account holding the exports.
      ContainerName: The blob container within the account to search.
      DownloadPath: |-
        Destination directory. Defaults to the download folder under the output root (Get-OutputRoot: <repo>/out
        locally, the artifact staging directory in a pipeline). Created if absent.
      Type: |-
        One or both rule types. Empty/omitted = both. The type word also serves as the name filter
        ('application' matches ...ApplicationRules..., 'network' matches ...NetworkRules...).
        Which rule type(s) to fetch: 'application', 'network', or both (the default when omitted). The type
        word is also used as the case-insensitive name filter for selecting the blob.
      TimestampPattern: |-
        Regex capturing the timestamp substring in the filename (UTC), the source of truth for generation time.
        Default '\d{2}-\d{2}-\d{4}-\d{2}-\d{2}'.
      TimestampFormat: '.NET ParseExact format for the captured timestamp, interpreted as UTC. Default ''dd-MM-yyyy-HH-mm''.'
    examples:
      - Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports
      - Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports -Type application
      - |-
        Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
            Convert-FirewallCsvToMarkdown -OutputFolder .\docs
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

    $DownloadPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DownloadPath)

    if (-not (Test-Path -Path $DownloadPath)) {
        New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
    }

    $common = "--subscription $SubscriptionId --account-name $StorageAccountName --container-name $ContainerName --auth-mode login"

    try {
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
            Invoke-AzCli "storage blob download $common --name `"$blobName`" --file `"$destination`" --overwrite true -o none"
        }
        catch {
            throw "Failed to download blob '$blobName' to '$destination'. Underlying: $_"
        }

        Assert-PathExist $destination -PathType Leaf -ErrorText "Blob '$blobName' reported success but no file is at '$destination'."

        [Catzc.Azure.Firewall.CsvExportRef]::new($ruleType, $destination, $pick.Generated, $blobName, $blob.properties.lastModified)
    }
}
