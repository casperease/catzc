<#
.SYNOPSIS
    Returns the folder the world-map PDFs are written to.
.DESCRIPTION
    This is the seam a test mocks to a folder of its own, so a run never writes into the real world-map folder.
    [ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2),
    [ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)
    [comment:1](/docs/references/automation/catzc-base-maps/Get-WorldMapOutputRoot.ps1.md#comment1)
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
