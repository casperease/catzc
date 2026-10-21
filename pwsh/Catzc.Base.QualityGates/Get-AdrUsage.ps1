<#
---
catzc:
  immutable:
    with_body_sha: "9590b80cbab6"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AdrUsage.Tests.ps1
    docs: "[Get-AdrUsage.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Get-AdrUsage.ps1.md)"
    cites:
      - ADR-PWSH-ERROR
      - ADR-REPO-FILEMETA-NOREADBACK
---
#>

function Get-AdrUsage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string[]] $Path,

        [string[]] $Code,

        [ValidateSet('cites', 'link')]
        [string] $Source,

        [ValidateSet('Rule', 'Document')]
        [string] $GroupBy
    )

    $map = Get-AdrCitationMap -RepositoryRoot $RepositoryRoot
    $config = Get-Config -Config file-meta
    $rows = foreach ($entry in Get-FileMetaScope -RepositoryRoot $RepositoryRoot -Path $Path -Config $config) {
        $carrier = $entry.Carrier.carrier
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Property -or $carrier -eq [Catzc.Base.Languages.CarrierKind]::Sidecar) {
            continue
        }
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $entry.Path))
        $arguments = @{ Text = $text; Path = $entry.Path; Map = $map }
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead) {
            $arguments['Form'] = $entry.Carrier.Form()
        }
        foreach ($row in Get-AdrUsageRow @arguments) {
            if ($Code -and $row.Code -notin $Code) {
                continue
            }
            if ($Source -and $row.Source -ne $Source) {
                continue
            }
            $row
        }
    }

    if ($GroupBy) {
        Group-AdrUsage -Row @($rows) -By $GroupBy
        return
    }
    $rows
}
