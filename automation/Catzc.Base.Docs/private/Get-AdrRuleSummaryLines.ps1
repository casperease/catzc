<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-AdrRuleSummaryLines.ps1
    kind: private-function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-LINK#5
  config:
    synopsis: Returns every line of every rule summary in one ADR file, with its line number and the rule's citation.
    description: |-
      A rule summary is the body of a `### Rule <code>:<n>` entry in an ADR's rule registry: every line from the line after the heading
      to the next heading. Blank lines, lines inside a fenced block, and the summary's own anchor bullets (`- [Section](#section)`, the
      internal links to the prose that justifies the rule) are left out: what remains is the normative text. The rule is named in its
      citation form, `<code>#<n>` ([ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)).

      Private helper for Test-AdrEngineNeutrality and the citation-graph check of Test-AdrRegistry; not exported.
    parameters:
      Path: The absolute path of the ADR markdown file.
    outputs: '[pscustomobject[]] One { Rule; Line; Text } per summary line, in file order; Line is 1-based.'
---
#>

function Get-AdrRuleSummaryLines {
    [OutputType([pscustomobject[]])]
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
