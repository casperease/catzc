# catzc:
#   path: automation/Catzc.Azure.Firewall/Convert-FirewallCsvToMarkdown.ps1
#   module: Catzc.Azure.Firewall
#   visibility: public

<#
.SYNOPSIS
    Renders an Azure Firewall rule-export CSV (application or network) as a Markdown document.
.DESCRIPTION
    Rows come out in firewall evaluation order, and a requested column the CSV lacks throws instead of rendering blank.
    [comment:1](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment1)
.PARAMETER CsvPath
    Path to the source CSV (Path set).
.PARAMETER MarkdownPath
    Output Markdown path (Path set).
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
.PARAMETER SourceName
    H1 title. Defaults to the CSV's own filename.
.PARAMETER GeneratedAt
    CSV generation time in UTC. When omitted, the preamble shows only the conversion time.
.PARAMETER InputObject
    A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).
.PARAMETER OutputFolder
    Unset, the file lands under the output root, which is out locally and the staging directory in a pipeline.
    [comment:2](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment2)
.PARAMETER SortNote
    The sentence under '## Rules' describing the ordering.
.EXAMPLE
    Convert-FirewallCsvToMarkdown -CsvPath .\application.csv -MarkdownPath .\docs\application.md
.EXAMPLE
    Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
        Convert-FirewallCsvToMarkdown -OutputFolder .\docs
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

        # The export omits group priority, so it is supplied here, and a group not listed sorts last.
        # [comment:3](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment3)
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
        [string]$OutputFolder = (Join-Path (Get-OutputRoot) 'markdown'),

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

        # Filled in the body, not as a default: in Object mode the value arrives from the pipeline after defaults run.
        # [ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)
        # [comment:4](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment4)
        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

        # The piped Object path is not validated by the parameter, so a wrong path fails here, named, not in Import-Csv.
        # [comment:5](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment5)
        Assert-PathExist $CsvPath -PathType Leaf

        $rows = @(Import-Csv -Path $CsvPath)
        $present = if ($rows.Count -gt 0) {
            $rows[0].PSObject.Properties.Name
        }
        else {
            @()
        }

        # An unknown group or a blank collection priority sorts last, never first, so unranked rules do not look urgent.
        # [comment:6](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment6)
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

        # The schema-mismatch throw for a column with no backing CSV field lives in the helper, not here.
        # [comment:7](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment7)
        $columnParams = @{
            RuleNameColumn         = $RuleNameColumn
            CompositeColumns       = $CompositeColumns
            ProtocolPortColumnName = $ProtocolPortColumnName
            AdditionalColumns      = $AdditionalColumns
            Present                = $present
        }
        $columns = Get-FirewallMarkdownColumns @columnParams

        $ret = [System.Text.StringBuilder]::new()

        # Times are UTC, so the output is the same on a CEST workstation and on a UTC build agent.
        # [comment:8](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment8)
        [void]$ret.AppendLine("# $SourceName")
        [void]$ret.AppendLine()
        $convertedUtc = [datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)
        if ($null -ne $GeneratedAt) {
            # The bound value is a plain datetime, so HasValue and Value do not exist on it.
            # [comment:9](/docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md#comment9)
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
