<#
---
catzc:
  immutable:
    with_body_sha: "1d35793ea6b8"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-WorldMapOutputRoot.Tests.ps1
    docs: "[Get-WorldMapOutputRoot.ps1.md](docs/references/pwsh/catzc-base-maps/private/Get-WorldMapOutputRoot.ps1.md)"
    cites:
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
      - ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER
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
