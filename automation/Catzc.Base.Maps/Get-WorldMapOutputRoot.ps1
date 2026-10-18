<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Maps/Get-WorldMapOutputRoot.ps1
    name: get-world-map-output-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Maps/tests/Get-WorldMapOutputRoot.Tests.ps1
    cites:
      - ADR-PWSH-PESTER#2
      - ADR-REPO-OUTDIR#2
---
#>

function Get-WorldMapOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $EnsureExists
    )

    $folder = Join-Path (Get-OutputRoot -EnsureExists:$EnsureExists) (Get-Config -Config maps).output_folder
    if ($EnsureExists -and -not (Test-Path -LiteralPath $folder -PathType Container)) {
        New-Item -Path $folder -ItemType Directory | Out-Null
    }
    $folder
}
