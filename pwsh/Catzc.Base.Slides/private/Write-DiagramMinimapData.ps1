<#
---
catzc:
  immutable:
    with_body_sha: fc4d346d96e8
  edges:
    docs: "[Write-DiagramMinimapData.ps1.md](docs/references/pwsh/catzc-base-slides/private/Write-DiagramMinimapData.ps1.md)"
---
#>

function Write-DiagramMinimapData {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Folder,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $maps = Get-Config -Config maps
    foreach ($folderPath in $Folder) {
        $source = Join-Path $RepositoryRoot "$folderPath/diagram.drawio.yml"
        $declaration = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($source)) -Ordered
        $about = if ($declaration -and $declaration.Contains('about')) {
            $declaration['about']
        }
        $content = if ($declaration -and $declaration.Contains('content')) {
            $declaration['content']
        }
        $adrs = [string[]] @(if ($about -and $about.Contains('adrs')) {
                $about['adrs']
            })
        Assert-True ($adrs.Count -gt 0) -ErrorText "Write-DiagramMinimapData: $folderPath names no ADR code in about.adrs, so its minimaps have no subject."
        $kind = if ($content -and $content.Contains('kind') -and $content['kind']) {
            "$($content['kind'])"
        }
        elseif ($folderPath -match '(^|/)references?/') {
            'reference'
        }
        else {
            'explanation'
        }
        $ids = [string[]] @(if ($content -and $content.Contains('minimaps') -and $content['minimaps']) {
                $content['minimaps']
            }
            else {
                $maps.MinimapsOf($kind).defaults
            })
        $target = Join-Path (Join-Path $RepositoryRoot 'out/minimaps') $folderPath
        $null = New-Item -ItemType Directory -Force -Path $target
        $utf8 = [System.Text.UTF8Encoding]::new($false)
        foreach ($id in $ids) {
            Assert-True ($maps.minimap_data.ContainsKey($id)) -ErrorText "Write-DiagramMinimapData: $folderPath names minimap '$id', which is not one of: $(@($maps.minimap_data.Keys) -join ', ')"
            $json = & $maps.minimap_data[$id] -Adr $adrs -AsJson
            [System.IO.File]::WriteAllText((Join-Path $target "$id.json"), "$json`n", $utf8)
        }
        [System.IO.File]::WriteAllText((Join-Path $target 'minimaps.json'), (ConvertTo-Json -InputObject $ids -Compress) + "`n", $utf8)
        $target
    }
}
