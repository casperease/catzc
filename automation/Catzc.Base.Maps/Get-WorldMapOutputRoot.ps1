<#
---
catzc:
  immutable:
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
  config:
    synopsis: Returns the folder the world-map PDFs are written to.
    description: |-
      The world map writes recurring files, so they land in their own folder under the output root
      ([ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)): Get-OutputRoot
      joined with the output_folder of configs/maps.yml (read through Get-Config, typed as Catzc.Base.Maps.MapsConfig;
      default world-map). It is also the seam a test mocks to a folder of its own
      ([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)).
    parameters:
      EnsureExists: Create the folder (and the output root) when it does not exist.
    outputs: '[string] the absolute folder path.'
    examples:
      - 'Get-WorldMapOutputRoot                    # -> <repository>/out/world-map'
      - Get-WorldMapOutputRoot -EnsureExists
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
