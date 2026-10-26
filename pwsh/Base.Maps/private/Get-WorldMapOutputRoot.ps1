<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/private/Get-WorldMapOutputRoot.ps1.md"
  header: "generated"
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
