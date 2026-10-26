function Format-MarkdownTablePadding {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    # Rebasing lengthens a table's links, so each table is padded again the way the formatter pads it; fences are left alone.
    $lines = @($Text -split "`n")
    $out = [System.Collections.Generic.List[string]]::new()
    $table = [System.Collections.Generic.List[string]]::new()
    $inFence = $false
    $flush = {
        if ($table.Count -eq 0) {
            return
        }
        $rows = foreach ($row in $table) {
            , @(($row.Trim().Trim('|') -split '(?<!\\)\|') | ForEach-Object { $_.Trim() })
        }
        $rows = @($rows)
        $columns = ($rows | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
        $widths = for ($c = 0; $c -lt $columns; $c++) {
            $max = 3
            for ($r = 0; $r -lt $rows.Count; $r++) {
                if ($r -ne 1 -and $c -lt $rows[$r].Count -and $rows[$r][$c].Length -gt $max) {
                    $max = $rows[$r][$c].Length
                }
            }
            $max
        }
        for ($r = 0; $r -lt $rows.Count; $r++) {
            $cells = for ($c = 0; $c -lt $columns; $c++) {
                if ($r -eq 1) {
                    '-' * $widths[$c]
                }
                elseif ($c -lt $rows[$r].Count) {
                    $rows[$r][$c].PadRight($widths[$c])
                }
                else {
                    ' ' * $widths[$c]
                }
            }
            $out.Add("| $(@($cells) -join ' | ') |")
        }
        $table.Clear()
    }

    foreach ($line in $lines) {
        if ($line -match '^\s*(```|~~~)') {
            $inFence = -not $inFence
        }
        if (-not $inFence -and $line -match '^\|') {
            $table.Add($line)
            continue
        }
        . $flush
        $out.Add($line)
    }
    . $flush
    $out -join "`n"
}
