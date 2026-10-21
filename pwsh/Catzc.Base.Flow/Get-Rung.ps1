<#
---
catzc:
  immutable:
    with_body_sha: "3839757d3d7d"
  edges:
    test: pwsh/Catzc.Base.Flow/tests/Get-Rung.Tests.ps1
    docs: "[Get-Rung.ps1.md](docs/references/pwsh/catzc-base-flow/Get-Rung.ps1.md)"
    cites:
      - ADR-FLOW-CD-RUNGSREGISTRY
---
#>

function Get-Rung {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Flow.Rung])]
    param(
        [ArgumentCompleter({ (Get-Config -Config rungs).rungs.name })]
        [string[]] $Name
    )

    foreach ($rung in (Get-Config -Config rungs).rungs) {
        if (-not $Name -or $Name -ccontains $rung.name) {
            $rung
        }
    }
}
