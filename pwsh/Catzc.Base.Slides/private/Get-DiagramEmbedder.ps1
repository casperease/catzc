<#
---
catzc:
  immutable:
    with_body_sha: e2464154a475
  edges:
    docs: "[Get-DiagramEmbedder.ps1.md](docs/references/pwsh/catzc-base-slides/private/Get-DiagramEmbedder.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-ONEBUILDCOMMAND
---
#>

function Get-DiagramEmbedder {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Tracked,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $embedders = @{}
    foreach ($page in @($Tracked | Where-Object { $_ -like '*.md' })) {
        $full = Join-Path $RepositoryRoot $page
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($full)
        if (-not $text.Contains('diagram.drawio.png')) {
            continue
        }
        $pageFolder = $page.Substring(0, [Math]::Max(0, $page.LastIndexOf('/')))
        foreach ($match in [regex]::Matches($text, '!\[[^\]]*\]\(([^)\s#]*diagram\.drawio\.png)')) {
            $target = $match.Groups[1].Value
            $joined = if ($target.StartsWith('/')) {
                $target.TrimStart('/')
            }
            else {
                "$pageFolder/$target"
            }
            $full = [System.IO.Path]::GetFullPath((Join-Path $RepositoryRoot $joined))
            $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $full) -replace '\\', '/'
            $folder = $relative.Substring(0, [Math]::Max(0, $relative.LastIndexOf('/')))
            if (-not $embedders.ContainsKey($folder)) {
                $embedders[$folder] = [System.Collections.Generic.List[string]]::new()
            }
            if (-not $embedders[$folder].Contains($page)) {
                $embedders[$folder].Add($page)
            }
        }
    }
    $embedders
}
