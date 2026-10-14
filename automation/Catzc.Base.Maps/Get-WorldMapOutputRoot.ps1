<#
.SYNOPSIS
    Returns the folder the world-map PDFs are written to.
.DESCRIPTION
    The world map writes recurring files, so they land in their own folder under the output root
    ([ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)): Get-OutputRoot
    joined with the output_folder of configs/maps.yml (read through Get-Config, typed as Catzc.Base.Maps.MapsConfig;
    default world-map). It is also the seam a test mocks to a folder of its own
    ([ADR-AUTO-PESTER#2](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester2)).
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
