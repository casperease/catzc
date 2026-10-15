<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/Get-WorldMapOutputRoot.ps1
    kind: function
    module: Catzc.Base.Maps
    visibility: public
    adrs:
      - ADR-PWSH-PESTER#2
      - ADR-REPO-OUTDIR#2
---
#>

<#
.SYNOPSIS
    Returns the folder the world-map PDFs are written to.
.DESCRIPTION
    This is the seam a test mocks to a folder of its own, so a run never writes into the real world-map folder.
.PARAMETER EnsureExists
    Create the folder (and the output root) when it does not exist.
.OUTPUTS
    [string] the absolute folder path.
.EXAMPLE
    Get-WorldMapOutputRoot                    # -> <repository>/out/world-map
.EXAMPLE
    Get-WorldMapOutputRoot -EnsureExists
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
