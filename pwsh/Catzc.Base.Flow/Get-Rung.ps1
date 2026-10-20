<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Flow/Get-Rung.ps1
    name: get-rung
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Flow
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
