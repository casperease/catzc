<#
---
catzc:
  immutable:
    with_body_sha: "0c93fbd82c17"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Get-DiagramMinimapReason.Tests.ps1
    docs: "[Get-DiagramMinimapReason.ps1.md](docs/references/pwsh/catzc-base-slides/private/Get-DiagramMinimapReason.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
---
#>

function Get-DiagramMinimapReason {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return
    }
    $reasons = [System.Collections.Generic.List[pscustomobject]]::new()
    $malformed = [System.Collections.Generic.List[string]]::new()
    $inSection = $false
    $number = 0
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        $number++
        if ($line -cmatch '^## ') {
            $inSection = $line -ceq '## Minimap reasons'
            continue
        }
        if (-not $inSection -or -not $line.Trim()) {
            continue
        }
        # A line Prettier wrapped continues the reason above it.
        if ($line -cmatch '^  \S' -and $reasons.Count -gt 0) {
            $reasons[$reasons.Count - 1].Reason += " $($line.Trim())"
            continue
        }
        $match = [regex]::Match($line, '^- (?<minimap>[a-z][a-z-]*): (?<reason>\S.*)$')
        if (-not $match.Success) {
            $malformed.Add("${number}: '$line' is not '- <minimap>: <reason>'")
            continue
        }
        $minimap = $match.Groups['minimap'].Value
        if ($minimap -cnotin [Catzc.Base.Maps.MinimapData]::Ids) {
            $malformed.Add("${number}: '$minimap' is not a minimap id ($([Catzc.Base.Maps.MinimapData]::Ids -join ', '))")
            continue
        }
        # One judged line per lit minimap: a second line for the same minimap is a second claim about it.
        if ($reasons | Where-Object Minimap -CEQ $minimap) {
            $malformed.Add("${number}: '$minimap' is named twice; one line per minimap")
            continue
        }
        $reasons.Add([pscustomobject]@{ Minimap = $minimap; Reason = $match.Groups['reason'].Value; Line = $number })
    }
    Assert-True ($malformed.Count -eq 0) -ErrorText "Get-DiagramMinimapReason: $Path has malformed minimap reasons:`n$($malformed -join "`n")"
    $reasons.ToArray()
}
