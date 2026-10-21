<#
---
catzc:
  immutable:
    with_body_sha: "2ed9d10b860b"
  edges:
    docs: "[Get-RepositoryWebUrl.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-RepositoryWebUrl.ps1.md)"
    cites:
      - ADR-REPO-LINK-OFFREPOSITORYURLS
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
