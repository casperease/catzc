<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-AdrRuleSummaryLines.ps1
    folder: private
    name: get-adr-rule-summary-lines
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1
    docs: "[Get-AdrRuleSummaryLines.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-AdrRuleSummaryLines.ps1.md)"
    cites:
      - ADR-REPO-LINK-ONECITATIONSPELLING
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
            if ($line -cmatch '^###\s+Rule\s+(?<code>ADR(?:-[A-Z][A-Z0-9]*){3,})\s*$') {
                $rule = $Matches['code']
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
