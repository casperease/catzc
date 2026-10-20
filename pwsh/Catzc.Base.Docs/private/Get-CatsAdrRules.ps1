<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-CatsAdrRules.ps1
    folder: private
    name: get-cats-adr-rules
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
    test: pwsh/Catzc.Base.Docs/tests/Get-CatsAdrRules.Tests.ps1
    docs: "[Get-CatsAdrRules.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-CatsAdrRules.ps1.md)"
    cites:
      - ADR-REPO-VOCAB-DEFINEDTERM
---
#>

function Get-CatsAdrRules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $AdrPath
    )

    Assert-PathExist $AdrPath

    $lines = [System.IO.File]::ReadAllLines($AdrPath)
    $ret = for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -cnotmatch '^###\s+Rule\s+(?<id>ADR(?:-[A-Z][A-Z0-9]*){3,})\s*$') {
            continue
        }
        $ruleId = $Matches['id']

        # The first paragraph: skip the padding blank lines, then read until the next blank line or heading.
        $paragraph = [System.Collections.Generic.List[string]]::new()
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $candidate = $lines[$j].Trim()
            if ($candidate -eq '') {
                if ($paragraph.Count -gt 0) {
                    break
                }
                continue
            }
            if ($candidate.StartsWith('#')) {
                break
            }
            $paragraph.Add($candidate)
        }

        $summary = ''
        if ($paragraph.Count -gt 0) {
            $summary = $paragraph[0]
        }

        [pscustomobject]@{
            Id        = $ruleId
            Summary   = $summary
            Statement = $paragraph -join ' '
        }
    }

    @($ret)
}
