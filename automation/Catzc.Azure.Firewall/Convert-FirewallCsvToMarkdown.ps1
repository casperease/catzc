<#
.SYNOPSIS
    Renders an Azure Firewall rule-export CSV (application or network) as a Markdown document.
.DESCRIPTION
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
.PARAMETER CsvPath
    Path to the source CSV (Path set).
.PARAMETER MarkdownPath
    Output Markdown path (Path set).
.PARAMETER SourceName
    H1 title. Defaults to the CSV's own filename.
.PARAMETER GeneratedAt
    CSV generation time in UTC. When omitted, the preamble shows only the conversion time.
.PARAMETER InputObject
    A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).
.PARAMETER OutputFolder
    Destination directory in Object mode; the file is named <original-name>.md. Defaults to <repo>/out/markdown.
.PARAMETER RuleNameColumn
    CSV column used as the rule name / first table column. Default 'Name'.
.PARAMETER CompositeColumns
    Ordered map of output column -> candidate CSV fields. Drives column order and which fields each cell pulls from.
.PARAMETER ProtocolPortColumnName
    Which composite column pairs protocols with ports (and is rendered unsorted). Default 'Protocol/Port'.
.PARAMETER IpGroupColumns
    Fields whose values are IP-group resource IDs, trimmed to the simple name. NOT for CIDRs.
.PARAMETER AdditionalColumns
    Extra single-field columns appended after the composites. Default the rule collection group and priority.
.PARAMETER MultiValueFields
    Fields split into multiple values on -SplitPattern.
.PARAMETER SplitPattern
    Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.
.PARAMETER CellListSeparator
    Separator joining multiple values within a cell. Default ', '.
.PARAMETER GroupPriority
    Rule collection group -> group priority (lower evaluated first). Not in the export, so supplied here.
.PARAMETER DoNotCutIpgNames
    Keep full IP-group resource IDs instead of trimming to the simple name.
.PARAMETER SortNote
    The sentence under '## Rules' describing the ordering.
.EXAMPLE
    Convert-FirewallCsvToMarkdown -CsvPath .\application.csv -MarkdownPath .\docs\application.md
.EXAMPLE
    Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
        Convert-FirewallCsvToMarkdown -OutputFolder .\docs
#>
function Convert-FirewallCsvToMarkdown {
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

        # Output column -> candidate CSV fields. Composite cells list every populated candidate.
        [Parameter()]
        [System.Collections.Specialized.OrderedDictionary]$CompositeColumns = ([ordered]@{
                Source          = @('SourceIpGroups', 'SourceAddresses')
                'Protocol/Port' = @('Protocols', 'DestinationPorts')
                Destination     = @(
                    'DestinationIpGroups', 'DestinationAddresses',
                    'DestinationFqdns', 'DestinationFqdnTag', 'WebCategories'
                )
            }),

        # The composite column that pairs protocols with ports (protocols:ports) and is left unsorted.
        [Parameter()]
        [string]$ProtocolPortColumnName = 'Protocol/Port',

        # Fields whose values are IP-group resource IDs (these get the simple-name trim). NOT for CIDRs.
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

        # Rule collection group -> group priority, for evaluation-order sorting (lower = evaluated first).
        # Not present in the export, so it's supplied here. Unlisted groups sort last.
        [Parameter()]
        [hashtable]$GroupPriority = @{
            'rcg-old' = 248
            'rcg-new' = 250
        },

        [Parameter()]
        [switch]$DoNotCutIpgNames,

        # Document title (H1). Defaults to the CSV's own filename.
        [Parameter(ParameterSetName = 'Path')]
        [string]$SourceName,

        # CSV generation time in UTC (from the filename, supplied by Get-FirewallCsv). Optional.
        [Parameter(ParameterSetName = 'Path')]
        [Nullable[datetime]]$GeneratedAt,

        # A Get-FirewallCsv result object (Type/Path/Generated/Blob/Modified). Pipeline-friendly.
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Object')]
        [psobject]$InputObject,

        # Where the .md goes in Object mode. Output file is <original-name>.md.
        [Parameter(ParameterSetName = 'Object')]
        [string]$OutputFolder = (Join-Path (Join-Path (Get-RepositoryRoot) 'out') 'markdown'),

        # Sentence under '## Rules' describing the ordering.
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

        # In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it
        # exists either way so a bad source path fails here, named, not as a raw Import-Csv error.
        Assert-PathExist $CsvPath -PathType Leaf

        $rows = @(Import-Csv -Path $CsvPath)
        $present = if ($rows.Count -gt 0) {
            $rows[0].PSObject.Properties.Name
        }
        else {
            @()
        }

        # Sort toward firewall evaluation order: rule collection GROUP priority first (from -GroupPriority),
        # then rule collection priority (e.g. allow=3000 before deny=3010), then rule name.
        # Unknown group and blank collection priority both sort last rather than first.
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

        # Build the ordered, validated column descriptors (rule name, composites, extras). Trimming to
        # $present headers and the schema-mismatch throw live in the helper.
        $columnParams = @{
            RuleNameColumn         = $RuleNameColumn
            CompositeColumns       = $CompositeColumns
            ProtocolPortColumnName = $ProtocolPortColumnName
            AdditionalColumns      = $AdditionalColumns
            Present                = $present
        }
        $columns = Get-FirewallMarkdownColumns @columnParams

        $ret = [System.Text.StringBuilder]::new()

        # Title + provenance preamble. Times are rendered in UTC; conversion time is taken now in UTC so it
        # doesn't depend on whether this runs on a CEST workstation or a UTC build agent.
        [void]$ret.AppendLine("# $SourceName")
        [void]$ret.AppendLine()
        $convertedUtc = [datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)
        if ($null -ne $GeneratedAt) {
            # PowerShell binds Nullable[datetime] as a plain [datetime], so check for $null and cast —
            # do NOT use .HasValue/.Value, which don't exist on the unwrapped struct.
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
