<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-RepositoryWebUrl.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-LINK#7
  config:
    synopsis: Returns this repository's GitHub web URL (https://github.com/<owner>/<repo>), or $null when it has none.
    description: |-
      Reads the origin remote from <root>/.git/config — no git process — and normalizes an https or ssh GitHub
      remote to its web URL. Test-Links uses it to recognise an absolute URL into this repository, which belongs
      only under .github/ ([ADR-REPO-LINK#7](/docs/adr/repository/markdown-links.md#rule-adr-repo-link7)). A root with no
      .git/config (a test fixture, an exported build) or a
      non-GitHub remote yields $null, and that check is skipped.
    parameters:
      RepositoryRoot: The repository root.
    outputs: '[string] or $null.'
---
#>

function Get-RepositoryWebUrl {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $gitConfig = Join-Path $RepositoryRoot '.git/config'
    if (-not (Test-Path $gitConfig -PathType Leaf)) {
        return $null
    }

    $inOrigin = $false
    foreach ($line in [System.IO.File]::ReadAllLines($gitConfig)) {
        if ($line -match '^\s*\[') {
            $inOrigin = $line -match '^\s*\[remote\s+"origin"\]'
            continue
        }
        if ($inOrigin -and $line -match '^\s*url\s*=\s*(?:https://github\.com/|git@github\.com:)(?<slug>[^/\s]+/[^/\s]+?)(?:\.git)?\s*$') {
            return "https://github.com/$($Matches['slug'])"
        }
    }
    $null
}
