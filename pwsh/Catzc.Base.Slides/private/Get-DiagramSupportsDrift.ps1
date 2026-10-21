<#
---
catzc:
  immutable:
    with_body_sha: "83c4e0bd162b"
  edges:
    docs: "[Get-DiagramSupportsDrift.ps1.md](../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramSupportsDrift.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-ONEBUILDCOMMAND
---
#>

function Get-DiagramSupportsDrift {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Stem,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Page,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [pscustomobject] $CarrierMap = (Get-DiagramCarrierMap -RepositoryRoot $RepositoryRoot)
    )

    $text = Get-DiagramDeclarationText -Stem $Stem -RepositoryRoot $RepositoryRoot -CarrierMap $CarrierMap
    if ($null -eq $text) {
        return
    }
    $declaration = ConvertFrom-Yaml -Yaml $text -Ordered
    $about = if ($declaration -and $declaration.Contains('about')) {
        $declaration['about']
    }
    $codes = [string[]] @(if ($about -and $about.Contains('adrs')) {
            $about['adrs']
        }) | Sort-Object -Unique
    $lens = if ($about -and $about.Contains('lens') -and $about['lens']) {
        "$($about['lens'])"
    }
    else {
        'meta'
    }
    $cited = (Get-Config -Config drs).CodeForm.Cited
    foreach ($pagePath in $Page) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $pagePath))
        $lines = @([regex]::Matches($text, '(?m)^Supports (.+?) \((\w+) lens\)\.?\s*$'))
        if ($lines.Count -eq 0) {
            continue
        }
        $agrees = @($lines | Where-Object {
                $said = [string[]] @([regex]::Matches($_.Groups[1].Value, $cited) | ForEach-Object Value) | Sort-Object -Unique
                $_.Groups[2].Value -ceq $lens -and (($said -join ' ') -ceq ($codes -join ' '))
            })
        if ($agrees.Count -eq 0) {
            "$pagePath says Supports $($lines[0].Groups[1].Value) ($($lines[0].Groups[2].Value) lens) for $Stem; its yml says $($codes -join ', ') ($lens lens)"
        }
    }
}
