<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/Convert-FirewallCsvToMarkdown.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Firewall
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md
      test: automation/Catzc.Azure.Firewall/tests/Convert-FirewallCsvToMarkdown.Tests.ps1
    adrs:
      - ADR-PWSH-PARAM#4
  config:
    synopsis: Renders an Azure Firewall rule-export CSV (application or network) as a Markdown document.
    description: |-
      Writes a titled Markdown file: an H1 of the source filename, a line with the CSV generation time and
      the conversion time (both UTC), then a '## Rules' section with a one-line ordering note and the table.

      Rows are sorted toward firewall evaluation order — rule collection GROUP priority (from -GroupPriority,
      since the export omits it), then rule collection priority, then rule name. Columns are composite: Source
      and Destination each list every populated candidate field (IP groups, addresses, FQDNs, FQDN tags, web
      categories), grouped by kind and sorted within a kind; Protocol/Port pairs protocols with ports and is
      left unsorted. IP-group resource IDs are trimmed to their simple name unless -DoNotCutIpgNames is set.
      A requested column with no backing field in the CSV is a schema mismatch and throws.

      Two parameter sets:
        Path   : -CsvPath + -MarkdownPath, with optional -SourceName / -GeneratedAt.
        Object : -InputObject (a Get-FirewallCsv result, pipeline-bindable) + optional -OutputFolder. CsvPath,
                 title, and generation time are taken from the object; the file is written as <name>.md.
    parameters:
      CsvPath: Path to the source CSV (Path set).
      MarkdownPath: Output Markdown path (Path set).
      RuleNameColumn: CSV column used as the rule name / first table column. Default 'Name'.
      CompositeColumns: |-
        Ordered map of output column -> candidate CSV fields. Drives column order and which fields each cell pulls
        from; a composite cell lists every populated candidate.
      ProtocolPortColumnName: Which composite column pairs protocols with ports (and is rendered unsorted). Default 'Protocol/Port'.
      IpGroupColumns: Fields whose values are IP-group resource IDs, trimmed to the simple name. NOT for CIDRs.
      AdditionalColumns: Extra single-field columns appended after the composites. Default the rule collection group and priority.
      MultiValueFields: Fields split into multiple values on -SplitPattern.
      SplitPattern: Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.
      CellListSeparator: Separator joining multiple values within a cell. Default ', '.
      GroupPriority: |-
        Rule collection group -> group priority, for evaluation-order sorting (lower = evaluated first).
        Not present in the export, so it's supplied here. Unlisted groups sort last.
      DoNotCutIpgNames: Keep full IP-group resource IDs instead of trimming to the simple name.
      SourceName: H1 title. Defaults to the CSV's own filename.
      GeneratedAt: |-
        CSV generation time in UTC, from the filename and supplied by Get-FirewallCsv. When omitted, the preamble
        shows only the conversion time.
      InputObject: A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).
      OutputFolder: |-
        Where the .md goes in Object mode; the file is named <original-name>.md.
        Destination directory in Object mode; the file is named <original-name>.md. Defaults to the markdown folder
        under the output root (Get-OutputRoot: <repo>/out locally, the artifact staging directory in a pipeline).
      SortNote: The sentence under '## Rules' describing the ordering.
    examples:
      - Convert-FirewallCsvToMarkdown -CsvPath .\application.csv -MarkdownPath .\docs\application.md
      - |-
        Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
            Convert-FirewallCsvToMarkdown -OutputFolder .\docs
---
#>

function Convert-FirewallCsvToMarkdown {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = 'In Object mode -SourceName derives from the piped input, bound after defaults are evaluated (ADR-PWSH-PARAM#4)')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'GroupPriority is consumed inside the Sort-Object Expression scriptblock, which this rule does not trace; the render-only parameters are forwarded to Get-FirewallMarkdownTable')]
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$CsvPath,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string]$MarkdownPath,

        [Parameter()]
        [string]$RuleNameColumn = 'Name',

        [Parameter()]
        [System.Collections.Specialized.OrderedDictionary]$CompositeColumns = ([ordered]@{
                Source          = @('SourceIpGroups', 'SourceAddresses')
                'Protocol/Port' = @('Protocols', 'DestinationPorts')
                Destination     = @(
                    'DestinationIpGroups', 'DestinationAddresses',
                    'DestinationFqdns', 'DestinationFqdnTag', 'WebCategories'
                )
            }),

        [Parameter()]
        [string]$ProtocolPortColumnName = 'Protocol/Port',

        [Parameter()]
        [string[]]$IpGroupColumns = @(
            'SourceIpGroups',
            'DestinationIpGroups'
        ),

        [Parameter()]
        [string[]]$AdditionalColumns = @('RuleCollectionGroup', 'RuleCollectionPriority'),

        [Parameter()]
        [string[]]$MultiValueFields = @(
            'SourceAddresses',
            'Protocols',
            'DestinationAddresses',
            'SourceIpGroups',
            'DestinationIpGroups',
            'DestinationPorts',
            'DestinationFqdns',
            'DestinationFqdnTag',
            'WebCategories'
        ),

        [Parameter()]
        [string]$SplitPattern = '\s*[,;]\s*',

        [Parameter()]
        [string]$CellListSeparator = ', ',

        [Parameter()]
        [hashtable]$GroupPriority = @{
            'rcg-old' = 248
            'rcg-new' = 250
        },

        [Parameter()]
        [switch]$DoNotCutIpgNames,

        [Parameter(ParameterSetName = 'Path')]
        [string]$SourceName,

        [Parameter(ParameterSetName = 'Path')]
        [Nullable[datetime]]$GeneratedAt,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Object')]
        [psobject]$InputObject,

        [Parameter(ParameterSetName = 'Object')]
        [string]$OutputFolder = (Join-Path (Get-OutputRoot) 'markdown'),

        [Parameter()]
        [string]$SortNote = (
            'Listed in evaluation order — collection group priority, then collection priority, then rule name. ' +
            'Source and Destination are grouped by kind and sorted within each kind.'
        )
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Object') {
            $CsvPath = $InputObject.Path
            $SourceName = Split-Path -Path $InputObject.Blob -Leaf
            $GeneratedAt = $InputObject.Generated

            if (-not (Test-Path -Path $OutputFolder)) {
                New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null
            }
            $markdownName = [System.IO.Path]::GetFileNameWithoutExtension($InputObject.Path) + '.md'
            $MarkdownPath = Join-Path $OutputFolder $markdownName
        }

        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

        Assert-PathExist $CsvPath -PathType Leaf

        $rows = @(Import-Csv -Path $CsvPath)
        $present = if ($rows.Count -gt 0) {
            $rows[0].PSObject.Properties.Name
        }
        else {
            @()
        }

        $sortProps = @()
        if ('RuleCollectionGroup' -in $present) {
            $sortProps += @{ Expression = {
                    $group = [string]$_.RuleCollectionGroup
                    if ($GroupPriority.ContainsKey($group)) {
                        [int]$GroupPriority[$group]
                    }
                    else {
                        [int]::MaxValue
                    }
                }
            }
            $sortProps += 'RuleCollectionGroup'
        }
        if ('RuleCollectionPriority' -in $present) {
            $sortProps += @{ Expression = { $number = [int]::MaxValue; [void][int]::TryParse([string]$_.RuleCollectionPriority, [ref]$number); $number } }
        }
        if ($RuleNameColumn -in $present) {
            $sortProps += $RuleNameColumn
        }
        if ($sortProps.Count) {
            $rows = @($rows | Sort-Object -Property $sortProps)
        }

        $columnParams = @{
            RuleNameColumn         = $RuleNameColumn
            CompositeColumns       = $CompositeColumns
            ProtocolPortColumnName = $ProtocolPortColumnName
            AdditionalColumns      = $AdditionalColumns
            Present                = $present
        }
        $columns = Get-FirewallMarkdownColumns @columnParams

        $ret = [System.Text.StringBuilder]::new()

        [void]$ret.AppendLine("# $SourceName")
        [void]$ret.AppendLine()
        $convertedUtc = [datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)
        if ($null -ne $GeneratedAt) {
            $generatedUtc = ([datetime]$GeneratedAt).ToUniversalTime().ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)
            [void]$ret.AppendLine("CSV generated $generatedUtc UTC · converted to Markdown $convertedUtc UTC.")
        }
        else {
            [void]$ret.AppendLine("Converted to Markdown $convertedUtc UTC.")
        }
        [void]$ret.AppendLine()
        [void]$ret.AppendLine('## Rules')
        [void]$ret.AppendLine()
        [void]$ret.AppendLine($SortNote)
        [void]$ret.AppendLine()

        $tableParams = @{
            Rows              = $rows
            Columns           = $columns
            MultiValueFields  = $MultiValueFields
            IpGroupColumns    = $IpGroupColumns
            SplitPattern      = $SplitPattern
            CellListSeparator = $CellListSeparator
            DoNotCutIpgNames  = $DoNotCutIpgNames
        }
        [void]$ret.Append((Get-FirewallMarkdownTable @tableParams))

        $outputDir = Split-Path -Path $MarkdownPath -Parent
        if ($outputDir -and -not (Test-Path -Path $outputDir)) {
            New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
        }

        Set-Content -Path $MarkdownPath -Value $ret.ToString() -Encoding UTF8
        Assert-PathExist $MarkdownPath -PathType Leaf
        Write-Message "wrote $MarkdownPath"
    }
}
