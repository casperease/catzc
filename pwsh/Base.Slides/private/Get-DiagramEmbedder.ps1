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

    # Stem to embedding pages: links resolve from the page's folder, or the root for '/'; a diagram names none of its pages.
    $embedders = @{}
    foreach ($page in @($Tracked | Where-Object { $_ -like '*.md' })) {
        $full = Join-Path $RepositoryRoot $page
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            continue
        }
        $text = [System.IO.File]::ReadAllText($full)
        if (-not $text.Contains('.drawio.png')) {
            continue
        }
        $pageFolder = $page.Substring(0, [Math]::Max(0, $page.LastIndexOf('/')))
        # A slide file embeds its diagram by the link under its `## Image` heading; any other page by a markdown image.
        $targets = @([regex]::Matches($text,
                '!\[[^\]]*\]\(([^)\s#]*\.drawio\.png)') | ForEach-Object { $_.Groups[1].Value })
        # The reference form is an equal embed: `![alt][ref]` with `[ref]: <path>.drawio.png` anywhere on the page.
        $used = @([regex]::Matches($text,
                '!\[[^\]]*\]\[([^\]]+)\]') | ForEach-Object { $_.Groups[1].Value.ToLowerInvariant() })
        foreach ($definition in [regex]::Matches($text, '(?m)^ {0,3}\[([^\]]+)\]:\s*(\S+\.drawio\.png)\s*$')) {
            if ($used -ccontains $definition.Groups[1].Value.ToLowerInvariant()) {
                $targets += $definition.Groups[2].Value
            }
        }
        if ($page -like '*.slide.md') {
            $source = [Catzc.Base.Slides.SlideSource]::Parse((Get-MarkdownMetaState -Text $text.Replace("`r`n", "`n")).Body)
            if ($source.Fields.ContainsKey('image')) {
                $image = $source.Fields['image']
                $target = if ($image.Items.Count -eq 1) {
                    $image.Items[0].Target
                }
                Assert-True ($null -ne $target) -ErrorText "Get-DiagramEmbedder: ${page}: the ## Image section holds one markdown link, [<stem>](<path>); found '$(@($image.Texts()) -join ' ')'."
                if ($target -like '*.drawio.png') {
                    $targets += $target
                }
            }
        }
        foreach ($target in $targets) {
            $joined = if ($target.StartsWith('/')) {
                $target.TrimStart('/')
            }
            else {
                "$pageFolder/$target"
            }
            $full = [System.IO.Path]::GetFullPath((Join-Path $RepositoryRoot $joined))
            $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $full) -replace '\\', '/'
            # The diagram is named by its stem, .assets/<name>, the key every diagram command uses.
            $folder = $relative -creplace '\.drawio\.png$', ''
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
