<#
---
catzc:
  immutable:
    with_body_sha: b6c28c4bd742
---
#>

function Get-MinimapSubject {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Adr
    )

    $map = Get-WorldMap
    $reasons = @(foreach ($cell in (Get-WorldMapHighlight -Adr $Adr).Cells) {
            foreach ($reason in $cell.Reasons) {
                if ($reason.Path) {
                    $reason
                }
            }
        })
    $facts = @{}
    $paths = @($reasons | ForEach-Object Path | Sort-Object -Unique)
    if ($paths.Count -gt 0) {
        foreach ($fact in @(Get-FileMetaFact -Path $paths)) {
            $facts[$fact.Path] = $fact.Immutable
        }
    }
    foreach ($reason in $reasons) {
        $placement = $map.Placement($reason.Path)
        [pscustomobject]@{
            Path      = $reason.Path
            Requested = $reason.Requested
            Citations = [string[]] @(if ($placement) {
                    $placement.Citations
                })
            Facts     = $facts[$reason.Path]
        }
    }
}
