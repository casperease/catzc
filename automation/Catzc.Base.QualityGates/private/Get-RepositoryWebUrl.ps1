<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-RepositoryWebUrl.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-LINK#7
---
#>

<#
.SYNOPSIS
    Returns this repository's GitHub web URL (https://github.com/<owner>/<repo>), or $null when it has none.
.DESCRIPTION
    A root without .git/config or with a non-GitHub remote yields null, and the absolute-URL link check is skipped.
.PARAMETER RepositoryRoot
    The repository root.
.OUTPUTS
    [string] or $null.
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
