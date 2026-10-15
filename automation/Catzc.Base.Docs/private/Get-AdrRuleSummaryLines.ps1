<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-AdrRuleSummaryLines.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns every line of every rule summary in one ADR file, with its line number and the rule's citation.
.DESCRIPTION
    Fences and anchor bullets are skipped, so only the normative text of each rule remains, not its justification.
    [ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-AdrRuleSummaryLines.ps1.md#comment1)
.PARAMETER Path
    The absolute path of the ADR markdown file.
.OUTPUTS
    [pscustomobject[]] One { Rule; Line; Text } per summary line, in file order; Line is 1-based.
#>
function Get-AdrRuleSummaryLines {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path

    $lines = [System.IO.File]::ReadAllLines($Path)
    $rule = $null
    $inFence = $false
    $ret = for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^\s*(```|~~~)') {
            $inFence = -not $inFence
            continue
        }
        if ($inFence) {
            continue
        }
        if ($line -match '^#{1,6}\s') {
            $rule = $null
            if ($line -cmatch '^###\s+Rule\s+(?<code>ADR-[A-Z]+(?:-[A-Z]+)*):(?<number>\d+)\s*$') {
                $rule = "$($Matches['code'])#$($Matches['number'])"
            }
            continue
        }
        if ($null -eq $rule -or $line.Trim() -eq '' -or $line -match '^\s*-\s+\[[^\]]*\]\(#[^)]*\)\s*$') {
            continue
        }
        [pscustomobject]@{
            Rule = $rule
            Line = $i + 1
            Text = $line
        }
    }

    @($ret)
}
