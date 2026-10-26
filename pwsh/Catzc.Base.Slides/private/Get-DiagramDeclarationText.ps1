<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramDeclarationText.ps1.md"
  header: "generated"
---
#>

function Get-DiagramDeclarationText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Stem,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # The yml beside the png wins (both is a drift finding); otherwise the article carrier's block.
    $source = Join-Path $RepositoryRoot "$Stem.drawio.yml"
    if ([System.IO.File]::Exists($source)) {
        return [System.IO.File]::ReadAllText($source)
    }
    # The article carrier: the one `yml drawio` block, in a page beside the diagram's .assets, directly above the image of its png.
    $name = $Stem.Substring($Stem.LastIndexOf('/') + 1)
    $assets = $Stem.Substring(0, [Math]::Max(0, $Stem.LastIndexOf('/')))
    $pageFolder = Join-Path $RepositoryRoot $assets.Substring(0, [Math]::Max(0, $assets.LastIndexOf('/')))
    $pattern = '(?m)^```yml drawio[ \t]*\r?\n((?:(?!```)[^\r\n]*\r?\n)*)```[ \t]*\r?\n(?:[ \t]*\r?\n)*!\[[^\]]*\]\((?:\./)?\.assets/' + [regex]::Escape($name) + '\.drawio\.png\)'
    # A slide is never a carrier: the deck shows its body, so a block there would be drawn as code.
    $bodies = @(foreach ($page in @(Get-ChildPath -Path $pageFolder -Depth 1 -Filter '*.md' -File | Where-Object { -not "$_".EndsWith('.slide.md') })) {
            foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($page), $pattern)) {
                $match.Groups[1].Value
            }
        })
    if ($bodies.Count -eq 1) {
        $bodies[0]
    }
}
