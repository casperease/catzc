<#
---
catzc:
  immutable:
    with_body_sha: "67d21c6d58f9"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Get-DiagramDeclarationText.Tests.ps1
    docs: "[Get-DiagramDeclarationText.ps1.md](../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramDeclarationText.ps1.md)"
---
#>

function Get-DiagramDeclarationText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Stem,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [pscustomobject] $CarrierMap
    )

    $carrier = if ($CarrierMap.Carriers.ContainsKey($Stem)) {
        $CarrierMap.Carriers[$Stem]
    }
    else {
        $CarrierMap.Default
    }
    if ($carrier -ceq 'file') {
        $source = Join-Path $RepositoryRoot "$Stem.drawio.yml"
        if ([System.IO.File]::Exists($source)) {
            return [System.IO.File]::ReadAllText($source)
        }
        return
    }
    # The article carrier: the one `yml drawio` block, in a page beside the diagram's .assets, directly above the image of its png.
    $name = $Stem.Substring($Stem.LastIndexOf('/') + 1)
    $assets = $Stem.Substring(0, [Math]::Max(0, $Stem.LastIndexOf('/')))
    $pageFolder = Join-Path $RepositoryRoot $assets.Substring(0, [Math]::Max(0, $assets.LastIndexOf('/')))
    $pattern = '(?m)^```yml drawio[ \t]*\r?\n((?:(?!```).*\r?\n)*)```[ \t]*\r?\n(?:[ \t]*\r?\n)*!\[[^\]]*\]\((?:\./)?\.assets/' + [regex]::Escape($name) + '\.drawio\.png\)'
    $bodies = @(foreach ($page in @(Get-ChildPath -Path $pageFolder -Depth 1 -Filter '*.md' -File)) {
            foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($page), $pattern)) {
                $match.Groups[1].Value
            }
        })
    if ($bodies.Count -eq 1) {
        $bodies[0]
    }
}
