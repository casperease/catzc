<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Get-DrsUsage.ps1.md"
  header: "generated"
---
#>

function Get-DrsUsage {
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

    $map = Get-DrsCitationMap -RepositoryRoot $RepositoryRoot
    $config = Get-Config -Config file-meta
    $pages = Get-Config -Config comment-pages
    $rows = foreach ($entry in Get-FileMetaScope -RepositoryRoot $RepositoryRoot -Path $Path -Config $config) {
        $carrier = $entry.Carrier.carrier
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::Property) {
            continue
        }
        $file = Join-Path $RepositoryRoot $entry.Path
        if (-not [System.IO.File]::Exists($file)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($file)
        $arguments = @{ Text = $text; Path = $entry.Path; Map = $map; Pages = $pages }
        if ($carrier -eq [Catzc.Base.Languages.CarrierKind]::CommentHead) {
            $arguments['Form'] = $entry.Carrier.Form()
        }
        foreach ($row in Get-DrsUsageRow @arguments) {
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
        Group-DrsUsage -Row @($rows) -By $GroupBy
        return
    }
    $rows
}
