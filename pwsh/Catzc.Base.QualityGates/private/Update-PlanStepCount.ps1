<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Update-PlanStepCount.ps1.md"
  header: "generated"
---
#>

function Update-PlanStepCount {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.PlansConfig] $Config,

        [switch] $DryRun
    )

    $counts = Get-PlanOpenStepCount $Folder -Config $Config
    # The stated phrase becomes the plan's count, its first letter's case kept; a text that states none is left as it is.
    $rewrite = {
        param([string] $Text, [int] $Count)
        $found = Resolve-PlanStepCount -Text $Text
        if (-not $found -or $found.Count -eq $Count) {
            return $Text
        }
        $phrase = Resolve-PlanStepCount -Count $Count
        if ([char]::IsUpper($Text[$found.Index])) {
            $phrase = [char]::ToUpperInvariant($phrase[0]) + $phrase.Substring(1)
        }
        $Text.Substring(0, $found.Index) + $phrase + $Text.Substring($found.Index + $found.Length)
    }
    $changed = [System.Collections.Generic.List[string]]::new()
    $write = -not $DryRun
    $save = {
        param([string] $Path, [string] $Before, [string[]] $Lines, [string] $Newline)
        $after = $Lines -join $Newline
        if ($after -cne $Before) {
            if ($write) {
                [System.IO.File]::WriteAllText($Path, $after, [System.Text.UTF8Encoding]::new($false))
            }
            $changed.Add($Path)
        }
    }

    # A chunk line of the master names its plan after '->'; the phrase is read across the item's lines, so a count Prettier wrapped is found.
    $master = Join-Path $Folder $Config.master_file
    if ([System.IO.File]::Exists($master)) {
        $text = [System.IO.File]::ReadAllText($master)
        $newline = $text.Contains("`r`n") ? "`r`n" : "`n"
        $lines = [System.Collections.Generic.List[string]]::new([string[]] ($text -split "`r?`n"))
        # From the last item up, so a rewrite that joins two lines never moves an item still to come.
        $items = @(Get-MarkdownListItem -Line $lines.ToArray())
        [Array]::Reverse($items)
        foreach ($item in $items) {
            if ($item.First -notmatch '->\s*(?<plan>plan-[^\s:]+\.md)\b' -or -not $counts.Contains($Matches['plan'])) {
                continue
            }
            $count = $counts[$Matches['plan']]
            $start = $item.LineNumber - 1
            $end = $start + 1
            while ($end -lt $lines.Count -and $lines[$end] -match '^\s{2,}\S') {
                $end++
            }
            $span = $lines.GetRange($start, $end - $start).ToArray() -join "`n"
            $rewritten = & $rewrite $span $count
            if ($rewritten -cne $span) {
                $lines.RemoveRange($start, $end - $start)
                $lines.InsertRange($start, [string[]] ($rewritten -split "`n"))
            }
        }
        & $save $master $text $lines.ToArray() $newline
    }

    # A row of the value overlay names its plan's topic in its second cell; the phrase sits in its last cell.
    $value = Join-Path $Folder $Config.value_file
    if ([System.IO.File]::Exists($value)) {
        $text = [System.IO.File]::ReadAllText($value)
        $newline = $text.Contains("`r`n") ? "`r`n" : "`n"
        $lines = $text -split "`r?`n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -notmatch '^\|[^|]*\|\s*(?<topic>plan-[^|\s]+)\s*\|' -or -not $counts.Contains("$($Matches['topic']).md")) {
                continue
            }
            $count = $counts["$($Matches['topic']).md"]
            $end = $lines[$i].TrimEnd().EndsWith('|') ? $lines[$i].LastIndexOf('|') : $lines[$i].Length
            $start = $lines[$i].LastIndexOf('|', $end - 1)
            $cell = $lines[$i].Substring($start + 1, $end - $start - 1)
            $lines[$i] = $lines[$i].Substring(0, $start + 1) + (& $rewrite $cell $count) + $lines[$i].Substring($end)
        }
        & $save $value $text $lines $newline
    }
    [string[]] $changed.ToArray()
}
