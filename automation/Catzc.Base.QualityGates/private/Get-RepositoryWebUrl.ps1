<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-RepositoryWebUrl.ps1
    folder: private
    name: get-repository-web-url
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-REPO-LINK#7
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
