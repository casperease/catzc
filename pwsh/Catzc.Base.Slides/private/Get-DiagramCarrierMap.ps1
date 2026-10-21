<#
---
catzc:
  immutable:
    with_body_sha: "0bf9fd6f84ae"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Get-DiagramCarrierMap.Tests.ps1
---
#>

function Get-DiagramCarrierMap {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string] $Kit = (Get-Config -Config slides).drawio_kit
    )

    # The kit's drawio.yml declares where a declaration lives: renderer.carrier for every diagram, and carriers: by stem for the rest.
    $path = Join-Path $RepositoryRoot "$Kit/configs/drawio.yml"
    Assert-PathExist $path -PathType Leaf -ErrorText "Get-DiagramCarrierMap: the draw.io kit '$Kit' has no configs/drawio.yml."
    $config = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($path)) -Ordered
    Assert-True ($config.Contains('renderer') -and $config['renderer'] -and $config['renderer'].Contains('carrier')) -ErrorText "Get-DiagramCarrierMap: $path declares no renderer.carrier."
    $carriers = @{}
    if ($config.Contains('carriers') -and $config['carriers']) {
        foreach ($stem in $config['carriers'].Keys) {
            $carriers["$stem"] = "$($config['carriers'][$stem])"
        }
    }
    [pscustomobject]@{ Default = "$($config['renderer']['carrier'])"; Carriers = $carriers }
}
