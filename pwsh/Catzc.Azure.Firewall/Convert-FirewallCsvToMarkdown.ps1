<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md"
  header: "generated"
---
#>

function Convert-FirewallCsvToMarkdown {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = 'In Object mode -SourceName derives from the piped input, bound after defaults are evaluated (ADR-PWSH-PARAM-RESOLUTIONORDER)')]
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

        # Filled in the body, not as a default: a piped path binds after the defaults are evaluated, so a default would never see it.
        if (-not $SourceName) {
            $SourceName = Split-Path -Path $CsvPath -Leaf
        }

        # Asserted in both modes, so a wrong source path fails here by name and never as a raw CSV read error.
        Assert-PathExist $CsvPath -PathType Leaf

        $rows = @(Import-Csv -Path $CsvPath)
        $present = @(if ($rows.Count -gt 0) {
                $rows[0].PSObject.Properties.Name
            }
            else {
                @()
            })

        # The firewall's own evaluation order: group priority, then collection priority, then name; an unknown sorts last, never first.
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

        # The columns are built and validated in one place, so a requested column the CSV lacks fails there instead of vanishing here.
        $columnParams = @{
            RuleNameColumn         = $RuleNameColumn
            CompositeColumns       = $CompositeColumns
            ProtocolPortColumnName = $ProtocolPortColumnName
            AdditionalColumns      = $AdditionalColumns
            Present                = $present
        }
        $columns = Get-FirewallMarkdownColumns @columnParams

        $ret = [System.Text.StringBuilder]::new()

        # Every time is rendered in UTC, so the same CSV gives the same page on a workstation and on a build agent.
        [void]$ret.AppendLine("# $SourceName")
        [void]$ret.AppendLine()
        $convertedUtc = [datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)
        if ($null -ne $GeneratedAt) {
            # A nullable date arrives unwrapped as a plain date, so it is null-checked and cast, never asked for HasValue or Value.
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
