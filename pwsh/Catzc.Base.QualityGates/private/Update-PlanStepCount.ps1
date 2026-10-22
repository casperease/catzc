<#
---
catzc:
  immutable:
    with_body_sha: b306f493f055
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Update-PlanStepCount.Tests.ps1
    docs: "[Update-PlanStepCount.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Update-PlanStepCount.ps1.md)"
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
    $save = {
        param([string] $Path, [string] $Before, [string[]] $Lines, [string] $Newline)
        $after = $Lines -join $Newline
        if ($after -cne $Before) {
            if (-not $DryRun) {
                [System.IO.File]::WriteAllText($Path, $after, [System.Text.UTF8Encoding]::new($false))
            }
            $changed.Add($Path)
        }
    }

    # A chunk line of the master names its plan after '->'; the phrase sits on the first line of the item that holds one.
    $master = Join-Path $Folder $Config.master_file
    if ([System.IO.File]::Exists($master)) {
        $text = [System.IO.File]::ReadAllText($master)
        $newline = $text.Contains("`r`n") ? "`r`n" : "`n"
        $lines = $text -split "`r?`n"
        foreach ($item in @(Get-MarkdownListItem -Line $lines)) {
            if ($item.First -notmatch '->\s*(?<plan>plan-[^\s:]+\.md)\b' -or -not $counts.Contains($Matches['plan'])) {
                continue
            }
            $count = $counts[$Matches['plan']]
            for ($i = $item.LineNumber - 1; $i -lt $lines.Count -and ($i -eq $item.LineNumber - 1 -or $lines[$i] -match '^\s{2,}\S'); $i++) {
                if (Resolve-PlanStepCount -Text $lines[$i]) {
                    $lines[$i] = & $rewrite $lines[$i] $count
                    break
                }
            }
        }
        & $save $master $text $lines $newline
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
