function Get-DiagramSupportsDrift {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Page,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # Each embedding page's `Supports <codes> (<lens> lens)` lines against the diagram's yml: a page passes when one of its lines
    # names the yml's ADR codes and lens, and a page with no Supports line is not checked. One warning per page that disagrees.
    $source = Join-Path $RepositoryRoot "$Folder/diagram.drawio.yml"
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        return
    }
    $declaration = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($source)) -Ordered
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
    foreach ($pagePath in $Page) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $pagePath))
        $lines = @([regex]::Matches($text, '(?m)^Supports (.+?) \((\w+) lens\)\.?\s*$'))
        if ($lines.Count -eq 0) {
            continue
        }
        $agrees = @($lines | Where-Object {
                $said = [string[]] @([regex]::Matches($_.Groups[1].Value, 'ADR(-[A-Z0-9]+)+') | ForEach-Object Value) | Sort-Object -Unique
                $_.Groups[2].Value -ceq $lens -and (($said -join ' ') -ceq ($codes -join ' '))
            })
        if ($agrees.Count -eq 0) {
            "$pagePath says Supports $($lines[0].Groups[1].Value) ($($lines[0].Groups[2].Value) lens) for $Folder; its yml says $($codes -join ', ') ($lens lens)"
        }
    }
}
