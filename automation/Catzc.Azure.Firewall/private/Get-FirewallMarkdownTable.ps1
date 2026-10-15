<#
.SYNOPSIS
    Renders the Markdown rule table (header + rows) for Convert-FirewallCsvToMarkdown.
.DESCRIPTION
    Builds the '| … |' table from already-sorted rows and the column descriptors from Get-FirewallMarkdownColumns: a...
    [comment:1](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md#comment1)
.PARAMETER Rows
    The rule rows, already sorted into evaluation order; each a CSV record (PSObject).
.PARAMETER Columns
    The ordered column descriptors from Get-FirewallMarkdownColumns (Name, Candidates, Sort, Render).
.PARAMETER MultiValueFields
    CSV fields split into multiple values on -SplitPattern.
.PARAMETER IpGroupColumns
    Fields whose values are IP-group resource IDs, trimmed to the simple name (unless -DoNotCutIpgNames).
.PARAMETER SplitPattern
    Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.
.PARAMETER CellListSeparator
    Separator joining multiple values within a cell. Default ', '.
.PARAMETER DoNotCutIpgNames
    Keep full IP-group resource IDs instead of trimming to the simple name.
.OUTPUTS
    [string] The Markdown table block (header, separator, and one line per row).
#>
function Get-FirewallMarkdownTable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'MultiValueFields/IpGroupColumns/SplitPattern/DoNotCutIpgNames are consumed inside the $renderField scriptblock, which this rule does not trace')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]]$Rows,

        [Parameter(Mandatory)]
        [object[]]$Columns,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$MultiValueFields,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$IpGroupColumns,

        [string]$SplitPattern = '\s*[,;]\s*',

        [string]$CellListSeparator = ', ',

        [switch]$DoNotCutIpgNames
    )

    $escapeCell = {
        param([string]$text)
        if ([string]::IsNullOrEmpty($text)) {
            return ''
        }
        ($text -replace '\r?\n', ' ' -replace '\|', '\|').Trim()
    }

    # Render a single CSV field to a list of escaped values: split multi-value, trim IP-group IDs.
    $renderField = {
        param([string]$columnName, [string]$raw)
        if ([string]::IsNullOrWhiteSpace($raw)) {
            return @()
        }

        if ($columnName -in $MultiValueFields) {
            $parts = @($raw -split $SplitPattern | Where-Object { $_ -ne '' })
            if (-not $DoNotCutIpgNames -and $columnName -in $IpGroupColumns) {
                $parts = @($parts | ForEach-Object { ($_ -split '/')[-1] })
            }
            return @($parts | ForEach-Object { & $escapeCell $_ })
        }
        @(& $escapeCell $raw)
    }

    $ret = [System.Text.StringBuilder]::new()
    [void]$ret.AppendLine('| ' + (($Columns | ForEach-Object { & $escapeCell $_.Name }) -join ' | ') + ' |')
    [void]$ret.AppendLine('| ' + (($Columns | ForEach-Object { '---' }) -join ' | ') + ' |')

    foreach ($row in $Rows) {
        $cells = foreach ($column in $Columns) {
            $cell = if ($column.Render -eq 'protoport') {
                # Pair protocols with ports as "protocols:ports" (e.g.
                # [comment:2](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md#comment2)
                $protocols = @()
                $ports = @()
                foreach ($candidate in $column.Candidates) {
                    $raw = [string]$row.$candidate
                    if ([string]::IsNullOrWhiteSpace($raw)) {
                        continue
                    }
                    $values = @(& $renderField $candidate $raw | Where-Object { $_ -ne '' })
                    if ($candidate -match 'Port') {
                        $ports += $values
                    }
                    else {
                        $protocols += $values
                    }
                }
                if ($protocols.Count -and $ports.Count) {
                    ($protocols -join '/') + ':' + ($ports -join ', ')
                }
                elseif ($ports.Count) {
                    $ports -join ', '
                }
                else {
                    $protocols -join ', '
                }
            }
            else {
                # Gather values per candidate, preserving candidate (group) order.
                # [comment:3](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md#comment3)
                $values = foreach ($candidate in $column.Candidates) {
                    $raw = [string]$row.$candidate
                    if (-not [string]::IsNullOrWhiteSpace($raw)) {
                        $group = @(& $renderField $candidate $raw | Where-Object { $_ -ne '' })
                        if ($column.Sort) {
                            $group = @($group | Sort-Object)
                        }
                        $group
                    }
                }
                @($values) -join $CellListSeparator
            }

            # Wrap a cell in backticks when Markdown would mangle it: - * or _ at a whitespace boundary (cell...
            # [comment:4](/docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md#comment4)
            if ($cell -match '^[*_]|[*_]$|\s[*_]|[*_]\s|https?://|ftp://|[a-z0-9-]+\.[a-z]{2,}') {
                '`' + $cell + '`'
            }
            else {
                $cell
            }
        }
        [void]$ret.AppendLine('| ' + ($cells -join ' | ') + ' |')
    }

    $ret.ToString()
}
