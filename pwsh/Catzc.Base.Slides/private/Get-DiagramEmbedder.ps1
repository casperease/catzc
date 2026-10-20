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

    # Every page that embeds a diagram, by the diagram's folder: each tracked markdown page's image links to a diagram.drawio.png,
    # resolved from the page's own folder, or from the repository root for a link that starts with '/'. Any number of pages may
    # embed one diagram; the diagram names none of them.
    $embedders = @{}
    foreach ($page in @($Tracked | Where-Object { $_ -like '*.md' })) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $page))
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
