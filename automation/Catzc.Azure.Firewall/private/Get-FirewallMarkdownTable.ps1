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
